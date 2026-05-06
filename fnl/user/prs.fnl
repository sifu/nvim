(local M {})

(local repo-path "/Users/sifu/prj/frontend-demo")

(fn strip-ansi [s]
  (let [(out _) (string.gsub s "\027%[[%d;]*[mK]" "")]
    out))

(var win-id nil)

(fn close []
  (when (and win-id (vim.api.nvim_win_is_valid win-id))
    (vim.api.nvim_win_close win-id true))
  (set win-id nil))

(fn current-line []
  (. (vim.api.nvim_buf_get_lines 0 (- (. (vim.api.nvim_win_get_cursor 0) 1) 1)
                                 (. (vim.api.nvim_win_get_cursor 0) 1) false)
     1))

(fn url-on-line [line]
  (string.match line "https?://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+"))

(fn branch-on-line [line]
  (string.match line "⎇%s+(%S+)"))

(fn checkout-branch [branch]
  (vim.notify (.. "Checking out " branch "…") vim.log.levels.INFO)
  (let [stderr-lines []]
    (vim.fn.jobstart ["git" "-C" repo-path "checkout" branch]
                     {:stderr_buffered true
                      :on_stderr (fn [_ data _]
                                   (when data
                                     (each [_ l (ipairs data)]
                                       (when (not= l "")
                                         (table.insert stderr-lines l)))))
                      :on_exit (fn [_ code _]
                                 (if (= code 0)
                                     (do
                                       (close)
                                       (vim.notify (.. "Switched to " branch)
                                                   vim.log.levels.INFO))
                                     (vim.notify (.. "git checkout failed: "
                                                     (table.concat stderr-lines
                                                                   "\n"))
                                                 vim.log.levels.ERROR)))})))

(fn handle-enter []
  (let [line (current-line)
        url (url-on-line line)
        branch (branch-on-line line)]
    (if url (vim.ui.open url) branch (checkout-branch branch)
        (vim.notify "No URL or branch on this line" vim.log.levels.WARN))))

(fn open-popup [lines]
  (close)
  (let [buf (vim.api.nvim_create_buf false true)
        ui (. (vim.api.nvim_list_uis) 1)
        width (math.min (math.max 80 (- ui.width 20)) 140)
        height (math.min (math.max 10 (length lines)) (- ui.height 6))
        opts {:relative "editor"
              : width
              : height
              :row (math.floor (/ (- ui.height height) 2))
              :col (math.floor (/ (- ui.width width) 2))
              :style "minimal"
              :border "rounded"
              :title " GitHub PRs "
              :title_pos "center"}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (vim.api.nvim_set_option_value "modifiable" false {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.api.nvim_set_option_value "filetype" "prs" {: buf})
    (set win-id (vim.api.nvim_open_win buf true opts))
    (vim.keymap.set "n" "q" close {:buffer buf :nowait true :silent true})
    (vim.keymap.set "n" "<esc>" close {:buffer buf :nowait true :silent true})
    (vim.keymap.set "n" "<cr>" handle-enter
                    {:buffer buf :nowait true :silent true})))

(fn M.show []
  (let [stdout-lines []
        stderr-lines []]
    (vim.notify "Loading PRs…" vim.log.levels.INFO)
    (vim.fn.jobstart ["bb" "/s/bin/prs.clj"]
                     {:stdout_buffered true
                      :stderr_buffered true
                      :on_stdout (fn [_ data _]
                                   (when data
                                     (each [_ line (ipairs data)]
                                       (table.insert stdout-lines
                                                     (strip-ansi line)))))
                      :on_stderr (fn [_ data _]
                                   (when data
                                     (each [_ line (ipairs data)]
                                       (when (not= line "")
                                         (table.insert stderr-lines line)))))
                      :on_exit (fn [_ code _]
                                 (while (and (> (length stdout-lines) 0)
                                             (= (. stdout-lines
                                                   (length stdout-lines))
                                                ""))
                                   (table.remove stdout-lines))
                                 (if (= code 0)
                                     (if (> (length stdout-lines) 0)
                                         (open-popup stdout-lines)
                                         (vim.notify "prs: no output"
                                                     vim.log.levels.WARN))
                                     (vim.notify (.. "prs failed (exit " code
                                                     "): "
                                                     (table.concat stderr-lines
                                                                   "\n"))
                                                 vim.log.levels.ERROR)))})))

M
