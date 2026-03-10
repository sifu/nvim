(fn copy-and-notify [text]
  (vim.cmd "silent! wa")
  (vim.fn.setreg "+" text)
  (vim.notify (.. "Copied: " text))
  text)

(fn copy-filepath-with-line []
  (let [filepath (vim.fn.expand "%")
        line-number (vim.fn.line ".")
        filepath-with-line (.. "@" filepath " on line " line-number)]
    (copy-and-notify filepath-with-line)))

(fn copy-file-reference []
  (let [filepath (vim.fn.expand "%:p")
        line-number (vim.fn.line ".")
        filepath-with-line (.. filepath ":" line-number)]
    (copy-and-notify filepath-with-line)))

(fn copy-filepath-raw []
  (copy-and-notify (vim.fn.expand "%:p")))

(fn copy-filepath []
  (let [filepath (vim.fn.expand "%")
        prefixed (.. "@" filepath)]
    (copy-and-notify prefixed)))

(fn copy-word-with-filepath []
  (let [word (vim.fn.expand "<cword>")
        filepath (vim.fn.expand "%:p")
        line-number (vim.fn.line ".")
        word-with-filepath (.. "`" word "` (@" filepath " on line " line-number
                               ")")]
    (copy-and-notify word-with-filepath)))

(fn open-prompt-buffer []
  (let [filepath (vim.fn.expand "%:.")
        line-number (vim.fn.line ".")
        buf (vim.api.nvim_create_buf false true)
        width (math.min 80 (- vim.o.columns 4))
        height (math.min 20 (- vim.o.lines 4))
        row (math.floor (/ (- vim.o.lines height) 2))
        col (math.floor (/ (- vim.o.columns width) 2))
        win (vim.api.nvim_open_win buf true
                                   {:relative "editor"
                                    : width
                                    : height
                                    : row
                                    : col
                                    :style "minimal"
                                    :border "rounded"
                                    :title " Prompt "
                                    :title_pos "center"})
        copy-and-close (fn []
                         (let [lines (vim.api.nvim_buf_get_lines buf 0 -1 false)
                               text (table.concat lines "\n")]
                           (vim.fn.setreg "+" text)
                           (vim.api.nvim_win_close win true)
                           (let [current (tonumber (vim.fn.system "tmux display-message -p '#{window_index}'"))
                                 windows (vim.fn.system "tmux list-windows -F '#{window_index} #{window_name}'")
                                 indices []]
                             (each [idx (string.gmatch windows "(%d+) Claude[^
]*")]
                               (table.insert indices (tonumber idx)))
                             (var target nil)
                             (each [_ idx (ipairs indices)]
                               (when (and (> idx current) (= target nil))
                                 (set target idx)))
                             (when (= target nil)
                               (when (> (length indices) 0)
                                 (set target (. indices 1))))
                             (if target
                                 (do
                                   (vim.fn.system (.. "tmux set-buffer -- "
                                                      (vim.fn.shellescape text)))
                                   (vim.fn.system (.. "tmux select-window -t "
                                                      target))
                                   (vim.fn.system "tmux paste-buffer")
                                   (vim.notify (.. "Pasted to Claude (window "
                                                   target ")")))
                                 (vim.notify "No Claude window found — copied to clipboard")))))]
    (let [initial-text (.. "@" filepath " on line " line-number)]
      (vim.api.nvim_buf_set_lines buf 0 -1 false [initial-text])
      (vim.api.nvim_set_option_value "filetype" "markdown" {: buf})
      (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
      (vim.api.nvim_win_set_cursor win [1 (+ 1 (length filepath))])
      (vim.keymap.set ["n" "i"] "<C-s>" copy-and-close {:buffer buf})
      (vim.keymap.set "n" "q" (fn [] (vim.api.nvim_win_close win true))
                      {:buffer buf}))))

(fn show-in-popup [lines]
  (let [buf (vim.api.nvim_create_buf false true)
        width (math.min 100 (- vim.o.columns 4))
        height (math.min (+ (length lines) 2) (- vim.o.lines 4))
        row (math.floor (/ (- vim.o.lines height) 2))
        col (math.floor (/ (- vim.o.columns width) 2))]
    (vim.api.nvim_open_win buf true
                           {:relative "editor"
                            : width
                            : height
                            : row
                            : col
                            :style "minimal"
                            :border "rounded"
                            :title " i18n Translation "
                            :title_pos "center"})
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (vim.api.nvim_set_option_value "modifiable" false {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.keymap.set "n" "q" "<cmd>close<cr>" {:buffer buf})
    (vim.keymap.set "n" "<esc>" "<cmd>close<cr>" {:buffer buf})))

(fn find-i18n-key []
  (vim.cmd "normal! yi'")
  (let [key (vim.fn.getreg "\"")]
    (when (and key (not= key ""))
      (vim.fn.setreg "+" key)
      (let [output (vim.fn.system (.. "/Users/sifu/.claude/skills/find-i18n/find-i18n.sh "
                                      (vim.fn.shellescape key)))
            lines (vim.split output "\n" {:trimempty true})]
        (show-in-popup lines)))))

(fn copy-filepath-with-line-range []
  (let [filepath (vim.fn.expand "%")
        start-line (. (vim.fn.getpos "v") 2)
        end-line (vim.fn.line ".")
        sorted-start (math.min start-line end-line)
        sorted-end (math.max start-line end-line)
        filepath-with-range (.. "@" filepath " line " sorted-start " to "
                                sorted-end)]
    (copy-and-notify filepath-with-range)))

{: copy-and-notify
 : copy-filepath-with-line
 : copy-file-reference
 : copy-filepath-raw
 : copy-filepath
 : copy-word-with-filepath
 : open-prompt-buffer
 : find-i18n-key
 : copy-filepath-with-line-range}
