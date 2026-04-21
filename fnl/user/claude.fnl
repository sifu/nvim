(local claude-bin (let [path (vim.fn.exepath "claude")]
                    (if (not= path "") path
                        (let [home (vim.fn.expand "$HOME")
                              local-bin (.. home "/.local/bin/claude")]
                          (if (= (vim.fn.executable local-bin) 1) local-bin
                              "claude")))))

(local timeout-ms 120000)

(var current-cancel nil)

(fn open-display-split []
  "Open a scratch split buffer seeded with a placeholder. Returns buf handle."
  (vim.cmd "botright new")
  (let [buf (vim.api.nvim_get_current_buf)]
    (vim.api.nvim_set_option_value "buftype" "nofile" {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.api.nvim_set_option_value "swapfile" false {: buf})
    (vim.api.nvim_set_option_value "filetype" "markdown" {: buf})
    (vim.api.nvim_buf_set_name buf "Claude")
    (vim.api.nvim_buf_set_lines buf 0 -1 false ["Claude is thinking..."])
    buf))

(fn set-buf-from-text [buf text]
  "Rewrite the entire buffer from a text string."
  (when (vim.api.nvim_buf_is_valid buf)
    (vim.api.nvim_buf_set_lines buf 0 -1 false (vim.split text "\n"))))

(fn replace-lines [buf start-line end-line text]
  "Replace lines in buffer (0-indexed start, end) with text (trailing \\n trimmed)."
  (let [lines (vim.split text "\n")
        n (length lines)]
    (when (and (> n 0) (= (. lines n) ""))
      (table.remove lines))
    (vim.api.nvim_buf_set_lines buf start-line end-line false lines)))

(fn set-busy [buf delta]
  "Bump vim.bo[buf].busy by delta (Neovim 0.11+). Silently no-op on older versions.
  Fires User ClaudeBusyChanged so statuslines can refresh."
  (when (vim.api.nvim_buf_is_valid buf)
    (pcall (fn []
             (let [opts (. vim.bo buf)
                   cur (or (. opts "busy") 0)
                   next-val (math.max 0 (+ cur delta))]
               (tset opts "busy" next-val))))
    (pcall vim.api.nvim_exec_autocmds "User" {:pattern "ClaudeBusyChanged"})))

(fn parse-stream-line [line]
  "Parse one line of stream-json. Returns (text, err) — only one is non-nil."
  (if (or (not line) (= line ""))
      (values nil nil)
      (let [(ok evt) (pcall vim.json.decode line)]
        (if (not (and ok (= (type evt) "table")))
            (values nil nil)
            (if (and (= evt.type "stream_event") evt.event
                     (= evt.event.type "content_block_delta") evt.event.delta
                     (= evt.event.delta.type "text_delta"))
                (values evt.event.delta.text nil)
                (and (= evt.type "result") evt.is_error)
                (values nil
                        (or evt.result
                            (.. "CLI error (subtype=" (tostring evt.subtype)
                                ")")))
                (values nil nil))))))

(fn run-claude-stream [system-prompt user-prompt callbacks]
  "Spawn `claude -p --output-format stream-json …` with the instruction+content
  piped via stdin (avoids argv parsing eating values that start with `-`, and
  avoids --append-system-prompt which gets echoed back by sessions with
  skill-injecting SessionStart hooks). Line-buffers stdout and invokes
  callbacks.on-text per text delta, callbacks.on-done on success,
  callbacks.on-error on failure. Returns a cancel thunk."
  (let [cmd [claude-bin
             "-p"
             "--output-format"
             "stream-json"
             "--verbose"
             "--include-partial-messages"]
        stdin-text (if (and system-prompt (not= system-prompt ""))
                       (.. system-prompt "\n\n" (or user-prompt ""))
                       (or user-prompt ""))]
    (var sbuf "")
    (var errbuf "")
    (var settled false)
    (var proc nil)
    (var timer nil)

    (fn settle [kind arg]
      (when (not settled)
        (set settled true)
        (when timer
          (let [t timer]
            (pcall (fn [] (t:stop) (t:close)))
            (set timer nil)))
        (vim.schedule (fn []
                        (if (= kind "done")
                            (when callbacks.on-done (callbacks.on-done))
                            (when callbacks.on-error (callbacks.on-error arg)))))))

    (fn on-chunk [_ chunk]
      (when (and chunk (not settled))
        (set sbuf (.. sbuf chunk))
        (var keep-going true)
        (while keep-going
          (let [nl (string.find sbuf "\n" 1 true)]
            (if nl
                (let [line (string.sub sbuf 1 (- nl 1))
                      (text err) (parse-stream-line line)]
                  (set sbuf (string.sub sbuf (+ nl 1)))
                  (if err
                      (do
                        (settle "error" err)
                        (set keep-going false))
                      (when (and text (not= text ""))
                        (vim.schedule (fn []
                                        (when (and (not settled)
                                                   callbacks.on-text)
                                          (callbacks.on-text text)))))))
                (set keep-going false))))))

    (fn on-stderr [_ chunk]
      (when (and chunk (not= chunk ""))
        (set errbuf (.. errbuf chunk))))

    (set proc (vim.system cmd {:text true
                               :stdin stdin-text
                               :stdout on-chunk
                               :stderr on-stderr
                               :env {:TMUX ""}}
                          (fn [result]
                            (if (and result.code (not= result.code 0))
                                (let [msg (if (and errbuf (not= errbuf ""))
                                              (string.sub errbuf 1 800)
                                              (or result.stderr "<no stderr>"))]
                                  (settle "error"
                                          (string.format "claude exited %d: %s"
                                                         result.code msg)))
                                (settle "done")))))
    (when (not settled)
      (set timer (vim.uv.new_timer))
      (timer:start timeout-ms 0
                   (vim.schedule_wrap (fn []
                                        (when (not settled)
                                          (when proc
                                            (let [p proc]
                                              (pcall (fn [] (p:kill 15)))))
                                          (settle "error"
                                                  (.. "claude timed out after "
                                                      (tostring timeout-ms) "ms")))))))
    (fn []
      (when (not settled)
        (when proc
          (let [p proc]
            (pcall (fn [] (p:kill 15)))))
        (settle "error" "cancelled")))))

(fn can-start []
  "Refuse to stack a second job on top of an in-flight one."
  (if current-cancel
      (do
        (vim.notify "Claude job already running; :ClaudeCancel to stop it"
                    vim.log.levels.WARN)
        false)
      true))

(fn run-replace [system-prompt user-prompt buf start-line end-line]
  "Stream into an accumulator; replace the line range as one undo unit on completion.
  Progress is surfaced via vim.bo[buf].busy (see set-busy) for lualine pickup."
  (let [state {:acc ""}]
    (set-busy buf 1)
    (set current-cancel
         (run-claude-stream system-prompt user-prompt
                            {:on-text (fn [chunk]
                                        (set state.acc (.. state.acc chunk)))
                             :on-done (fn []
                                        (set current-cancel nil)
                                        (set-busy buf -1)
                                        (when (vim.api.nvim_buf_is_valid buf)
                                          (replace-lines buf start-line
                                                         end-line state.acc))
                                        (vim.notify "Claude done"
                                                    vim.log.levels.INFO))
                             :on-error (fn [msg]
                                         (set current-cancel nil)
                                         (set-busy buf -1)
                                         (vim.notify (.. "Claude failed: " msg)
                                                     vim.log.levels.ERROR))}))))

(fn run-display [system-prompt user-prompt]
  "Open split immediately; stream tokens into it as they arrive."
  (let [split-buf (open-display-split)
        state {:acc "" :started false}]
    (set current-cancel
         (run-claude-stream system-prompt user-prompt
                            {:on-text (fn [chunk]
                                        (when (not state.started)
                                          (set state.started true)
                                          (set state.acc ""))
                                        (set state.acc (.. state.acc chunk))
                                        (set-buf-from-text split-buf state.acc))
                             :on-done (fn []
                                        (set current-cancel nil)
                                        (vim.notify "Claude done"
                                                    vim.log.levels.INFO))
                             :on-error (fn [msg]
                                         (set current-cancel nil)
                                         (when (vim.api.nvim_buf_is_valid split-buf)
                                           (set state.acc
                                                (.. state.acc "\n\n[error: "
                                                    msg "]"))
                                           (set-buf-from-text split-buf
                                                              state.acc))
                                         (vim.notify (.. "Claude failed: " msg)
                                                     vim.log.levels.ERROR))}))))

(fn range-slice [line1 line2]
  "Extract (start-0idx, end-0idx, joined-text) from a :range-style command args."
  (let [start-line (- (math.min line1 line2) 1)
        end-line (math.max line1 line2)
        lines (vim.api.nvim_buf_get_lines 0 start-line end-line false)]
    (values start-line end-line (table.concat lines "\n"))))

(fn register-commands []
  "Register all Claude user commands"
  (let [replace-cmds {:ClaudeGrammar "Fix grammar and spelling. Return ONLY the corrected text, nothing else."
                      :ClaudeDocstring "Add documentation comments to this code. Return ONLY the documented code, no explanations or markdown fences."
                      :ClaudeTests "Write unit tests for this code. Return ONLY the test code, no explanations or markdown fences."
                      :ClaudeOptimize "Optimize this code. Return ONLY the optimized code, no explanations or markdown fences."
                      :ClaudeFixBugs "Fix any bugs in this code. Return ONLY the fixed code, no explanations or markdown fences."}
        display-cmds {:ClaudeExplain "Explain what this code does in detail."
                      :ClaudeSummarize "Summarize this text concisely."
                      :ClaudeReadability "Analyze the readability of this code and suggest improvements."}]
    (each [name system-prompt (pairs replace-cmds)]
      (vim.api.nvim_create_user_command name
                                        (fn [args]
                                          (when (can-start)
                                            (let [(start-line end-line text) (range-slice args.line1
                                                                                          args.line2)
                                                  buf (vim.api.nvim_get_current_buf)]
                                              (run-replace system-prompt text
                                                           buf start-line
                                                           end-line))))
                                        {:range true}))
    (each [name system-prompt (pairs display-cmds)]
      (vim.api.nvim_create_user_command name
                                        (fn [args]
                                          (when (can-start)
                                            (let [(_ _ text) (range-slice args.line1
                                                                          args.line2)]
                                              (run-display system-prompt text))))
                                        {:range true})))
  (vim.api.nvim_create_user_command "ClaudeEdit"
                                    (fn [args]
                                      (when (can-start)
                                        (let [(start-line end-line text) (range-slice args.line1
                                                                                      args.line2)
                                              buf (vim.api.nvim_get_current_buf)]
                                          (vim.ui.input {:prompt "Edit instruction: "}
                                                        (fn [instruction]
                                                          (when (and instruction
                                                                     (not= instruction
                                                                           ""))
                                                            (let [system-prompt "Apply the user's edit instruction to the code. Return ONLY the modified code, no explanations or markdown fences."
                                                                  user-prompt (.. "Instruction: "
                                                                                  instruction
                                                                                  "

Code:
"
                                                                                  text)]
                                                              (run-replace system-prompt
                                                                           user-prompt
                                                                           buf
                                                                           start-line
                                                                           end-line))))))))
                                    {:range true})
  (vim.api.nvim_create_user_command "ClaudeTranslate"
                                    (fn [args]
                                      (when (can-start)
                                        (let [(start-line end-line text) (range-slice args.line1
                                                                                      args.line2)
                                              buf (vim.api.nvim_get_current_buf)]
                                          (vim.ui.input {:prompt "Translate to: "}
                                                        (fn [language]
                                                          (when (and language
                                                                     (not= language
                                                                           ""))
                                                            (let [system-prompt (.. "Translate the user's text to "
                                                                                    language
                                                                                    ". Return ONLY the translated text, nothing else.")]
                                                              (run-replace system-prompt
                                                                           text
                                                                           buf
                                                                           start-line
                                                                           end-line))))))))
                                    {:range true})
  (vim.api.nvim_create_user_command "ClaudeCancel"
                                    (fn []
                                      (if current-cancel
                                          (let [c current-cancel]
                                            (set current-cancel nil)
                                            (c))
                                          (vim.notify "no Claude job running"
                                                      vim.log.levels.INFO)))
                                    {}))

(fn chat []
  "Open interactive Claude chat in a terminal split"
  (vim.cmd "botright split")
  (vim.cmd "terminal claude")
  (vim.cmd "startinsert"))

;; Register commands on module load
(register-commands)

{: chat}
