(local claude-bin (let [path (vim.fn.exepath "claude")]
                    (if (not= path "") path
                        (let [home (vim.fn.expand "$HOME")
                              local-bin (.. home "/.local/bin/claude")]
                          (if (= (vim.fn.executable local-bin) 1) local-bin
                              "claude")))))

(fn show-thinking []
  "Show a floating window indicator while Claude is working"
  (let [buf (vim.api.nvim_create_buf false true)
        text " Claude is thinking... "
        width (length text)
        cols vim.o.columns
        opts {:relative "editor"
              : width
              :height 1
              :col (- (math.floor (/ cols 2)) (math.floor (/ width 2)))
              :row 1
              :style "minimal"
              :border "rounded"
              :zindex 50}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false [text])
    (vim.api.nvim_open_win buf false opts)))

(fn hide-thinking [win]
  "Close the thinking indicator"
  (when (and win (vim.api.nvim_win_is_valid win))
    (vim.api.nvim_win_close win true)))

(fn show-in-split [text]
  "Show output text in a scratch split buffer"
  (vim.cmd "botright new")
  (let [buf (vim.api.nvim_get_current_buf)
        lines (vim.split text "\n")]
    (vim.api.nvim_set_option_value "buftype" "nofile" {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.api.nvim_set_option_value "swapfile" false {: buf})
    (vim.api.nvim_set_option_value "filetype" "markdown" {: buf})
    (vim.api.nvim_buf_set_name buf "Claude")
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)))

(fn replace-lines [buf start-line end-line text]
  "Replace lines in buffer (0-indexed start, end)"
  (let [lines (vim.split text "\n")
        n (length lines)]
    (when (and (> n 0) (= (. lines n) ""))
      (table.remove lines))
    (vim.api.nvim_buf_set_lines buf start-line end-line false lines)))

(fn handle-result [result mode buf start-line end-line win]
  "Handle the claude command result"
  (hide-thinking win)
  (if (= result.code 0)
      (do
        (if (= mode "replace")
            (replace-lines buf start-line end-line result.stdout)
            (show-in-split result.stdout))
        (vim.notify "Claude done" vim.log.levels.INFO))
      (vim.notify (.. "Claude failed: "
                      (or result.stderr (tostring result.code)))
                  vim.log.levels.ERROR)))

(fn run-claude-range [line1 line2 prompt mode]
  "Run claude on a line range. line1/line2 are 1-indexed."
  (let [start-line (- (math.min line1 line2) 1)
        end-line (math.max line1 line2)
        lines (vim.api.nvim_buf_get_lines 0 start-line end-line false)
        text (table.concat lines "\n")
        buf (vim.api.nvim_get_current_buf)
        full-prompt (.. prompt "\n\n" text)
        win (show-thinking)]
    (vim.system [claude-bin "-p" full-prompt "--output-format" "text"] {}
                (vim.schedule_wrap (fn [result]
                                     (handle-result result mode buf start-line
                                                    end-line win))))))

(fn register-commands []
  "Register all Claude user commands"
  (let [commands {:ClaudeGrammar {:prompt "Fix grammar and spelling. Return ONLY the corrected text, nothing else."
                                  :mode "replace"}
                  :ClaudeDocstring {:prompt "Add documentation comments to this code. Return ONLY the documented code, no explanations or markdown fences."
                                    :mode "replace"}
                  :ClaudeTests {:prompt "Write unit tests for this code. Return ONLY the test code, no explanations or markdown fences."
                                :mode "replace"}
                  :ClaudeOptimize {:prompt "Optimize this code. Return ONLY the optimized code, no explanations or markdown fences."
                                   :mode "replace"}
                  :ClaudeFixBugs {:prompt "Fix any bugs in this code. Return ONLY the fixed code, no explanations or markdown fences."
                                  :mode "replace"}
                  :ClaudeExplain {:prompt "Explain what this code does in detail."
                                  :mode "display"}
                  :ClaudeSummarize {:prompt "Summarize this text concisely."
                                    :mode "display"}
                  :ClaudeReadability {:prompt "Analyze the readability of this code and suggest improvements."
                                      :mode "display"}}]
    (each [name opts (pairs commands)]
      (vim.api.nvim_create_user_command name
                                        (fn [args]
                                          (run-claude-range args.line1
                                                            args.line2
                                                            opts.prompt
                                                            opts.mode))
                                        {:range true})))
  (vim.api.nvim_create_user_command "ClaudeEdit"
                                    (fn [args]
                                      (let [start-line (- (math.min args.line1
                                                                    args.line2)
                                                          1)
                                            end-line (math.max args.line1
                                                               args.line2)
                                            lines (vim.api.nvim_buf_get_lines 0
                                                                              start-line
                                                                              end-line
                                                                              false)
                                            text (table.concat lines "\n")
                                            buf (vim.api.nvim_get_current_buf)]
                                        (vim.ui.input {:prompt "Edit instruction: "}
                                                      (fn [instruction]
                                                        (when (and instruction
                                                                   (not= instruction
                                                                         ""))
                                                          (let [full-prompt (.. "Apply this edit instruction to the code below. Return ONLY the modified code, no explanations or markdown fences.

Instruction: "
                                                                                instruction
                                                                                "

Code:
"
                                                                                text)
                                                                win (show-thinking)]
                                                            (vim.system [claude-bin
                                                                         "-p"
                                                                         full-prompt
                                                                         "--output-format"
                                                                         "text"]
                                                                        {}
                                                                        (vim.schedule_wrap (fn [result]
                                                                                             (handle-result result
                                                                                                            "replace"
                                                                                                            buf
                                                                                                            start-line
                                                                                                            end-line
                                                                                                            win))))))))))
                                    {:range true})
  (vim.api.nvim_create_user_command "ClaudeTranslate"
                                    (fn [args]
                                      (vim.ui.input {:prompt "Translate to: "}
                                                    (fn [language]
                                                      (when (and language
                                                                 (not= language
                                                                       ""))
                                                        (run-claude-range args.line1
                                                                          args.line2
                                                                          (.. "Translate this text to "
                                                                              language
                                                                              ". Return ONLY the translated text, nothing else.")
                                                                          "replace")))))
                                    {:range true}))

(fn chat []
  "Open interactive Claude chat in a terminal split"
  (vim.cmd "botright split")
  (vim.cmd "terminal claude")
  (vim.cmd "startinsert"))

;; Register commands on module load
(register-commands)

{: chat}
