(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local str (autoload "nfnl.string"))

;; example entries:
;; [2024-11-18 13:09 - 2024-11-18 15:06] ISSUE-1234 some comment 
;; [2024-11-18 19:09 - 2024-11-19 11:06] ISSUE-4444 some comment 
;; [2024-11-19 19:09 - 2025-01-02 18:04] ISSUE-1111 not enddate yet
;; [2025-01-02 18:04 - 2025-01-02 18:08] ISSUE-1234 some comment 
;; [2025-01-02 18:08 - 2025-01-02 18:12] ISSUE-1234 some comment 
;; [2025-01-02 18:12] ISSUE-1111 not enddate yet

(local timestamp-regex "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d")
(local log-statement-regex "^%[.*%](%s*.*)$")

(fn now [] (os.date "%Y-%m-%d %H:%M"))

(fn date-string->time [date-string]
  (let [(year month day hour min) (string.match date-string
                                                "(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d)")]
    (os.time {:year (tonumber year)
              :month (tonumber month)
              :day (tonumber day)
              :hour (tonumber hour)
              :min (tonumber min)})))

(fn diff-time-in-seconds [[start end]]
  (os.difftime (if end (date-string->time end) (os.time))
               (date-string->time start)))

(fn is-timelog-line? [line]
  (not= nil (string.find line "^%[[%d%-%s:]*%]")))

(fn get-timestamps [line]
  (str.split (string.match line "^%[(.*)%]") "%s%-%s"))

(fn line->duration [line] (diff-time-in-seconds (get-timestamps line)))

(fn format-duration [duration]
  (let [minutes (math.floor (/ duration 60))
        hours (math.floor (/ minutes 60))
        days (math.floor (/ hours 24))
        remaining-hours (% hours 24)
        remaining-minutes (% minutes 60)
        parts []
        _ (when (> days 0)
            (table.insert parts (.. days "d")))
        _ (when (> remaining-hours 0)
            (table.insert parts (.. remaining-hours "h")))
        _ (when (> remaining-minutes 0)
            (table.insert parts (.. remaining-minutes "m")))]
    (if (core.empty? parts) " 0m"
        (.. " " (table.concat parts " ")))))

(fn is-running? [line]
  (= 1 (length (get-timestamps line))))

(fn get-timelog-lines [lines]
  (core.filter is-timelog-line? lines))

(fn stop-task [line]
  (let [timestamp (string.match line timestamp-regex)
        log-statement (string.match line log-statement-regex)]
    (.. "[" timestamp " - " (now) "]" log-statement)))

(local timetracking-ns
       (vim.api.nvim_create_namespace "timetracking_virtual_text"))

(var current-extmark-id nil)

(fn clear-virtual-text []
  (when current-extmark-id
    (let [buf (vim.api.nvim_get_current_buf)]
      (vim.api.nvim_buf_del_extmark buf timetracking-ns current-extmark-id)
      (set current-extmark-id nil))))

(fn show-virtual-text [text]
  (clear-virtual-text)
  (let [buf (vim.api.nvim_get_current_buf)
        line (. (vim.api.nvim_win_get_cursor 0) 1)
        opts {:virt_text [[text "Comment"]] :virt_text_pos "right_align"}]
    (set current-extmark-id
         (vim.api.nvim_buf_set_extmark buf timetracking-ns (- line 1) 0 opts))))

(vim.api.nvim_create_autocmd ["CursorMoved" "CursorMovedI"]
                             {:callback (fn [] (clear-virtual-text))
                              :group (vim.api.nvim_create_augroup "TimetrackingVirtualText"
                                                                  {:clear true})})

(fn check-current-line []
  (clear-virtual-text)
  (let [buf (vim.api.nvim_get_current_buf)
        [row] (vim.api.nvim_win_get_cursor 0)
        current-line (. (vim.api.nvim_buf_get_lines buf (- row 1) row false) 1)]
    (when (is-timelog-line? current-line)
      (show-virtual-text (format-duration (line->duration current-line))))))

(fn get-visual-selection []
  (let [start-pos (vim.fn.getpos "'<")
        end-pos (vim.fn.getpos "'>")
        start-line (- (. start-pos 2) 1)
        end-line (. end-pos 2)
        buf (vim.api.nvim_get_current_buf)]
    (vim.api.nvim_buf_get_lines buf start-line end-line false)))

(fn sum-durations [lines]
  (accumulate [total 0 line (core.iter (get-timelog-lines lines))]
    (+ total (line->duration line))))

(var popup-win-id nil)

(fn close-popup []
  (when popup-win-id
    (when (vim.api.nvim_win_is_valid popup-win-id)
      (vim.api.nvim_win_close popup-win-id true))
    (set popup-win-id nil)))

(fn show-popup [text]
  (close-popup)
  (let [buf (vim.api.nvim_create_buf false true)
        width 30
        height 1
        opts {:relative "cursor"
              : width
              : height
              :row 1
              :col 0
              :style "minimal"
              :border "rounded"}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false [text])
    (set popup-win-id (vim.api.nvim_open_win buf false opts))
    (vim.api.nvim_create_autocmd ["CursorMoved" "CursorMovedI"]
                                 {:callback close-popup :once true})))

(fn sum-selected-durations []
  (let [lines (get-visual-selection)
        total (sum-durations lines)]
    (show-popup (.. "Total: " (format-duration total)))))

(fn close-running-task []
  (let [buf (vim.api.nvim_get_current_buf)
        lines (vim.api.nvim_buf_get_lines buf 0 -1 false)]
    (var running-line-idx nil) ; Find the running task
    (each [idx line (ipairs lines)]
      (when (and (is-timelog-line? line) (is-running? line))
        (set running-line-idx (- idx 1)))) ; Replace the line if found
    (when running-line-idx
      (let [running-line (. lines (+ running-line-idx 1))
            stopped-line (stop-task running-line)]
        (vim.api.nvim_buf_set_lines buf running-line-idx (+ running-line-idx 1)
                                    false [stopped-line])))))

(fn get-message-from-line [line]
  (string.match line log-statement-regex))

(fn create-new-task [message]
  (.. "[" (now) "]" message))

(fn append-new-task-with-current-message []
  (let [buf (vim.api.nvim_get_current_buf)
        [row] (vim.api.nvim_win_get_cursor 0)
        current-line (. (vim.api.nvim_buf_get_lines buf (- row 1) row false) 1)]
    (when (is-timelog-line? current-line)
      (close-running-task)
      (let [message (get-message-from-line current-line)
            new-line (create-new-task message)]
        (vim.api.nvim_buf_set_lines buf -1 -1 false [new-line])
        (vim.cmd "norm! G")))))

(fn append-new-task []
  (let [buf (vim.api.nvim_get_current_buf)
        [row] (vim.api.nvim_win_get_cursor 0)
        current-line (. (vim.api.nvim_buf_get_lines buf (- row 1) row false) 1)]
    (when (is-timelog-line? current-line)
      (close-running-task)
      (let [new-line (create-new-task " ")]
        (vim.api.nvim_buf_set_lines buf -1 -1 false [new-line])
        (vim.cmd "norm! G")))))

(vim.api.nvim_create_user_command "TimeTrackingSum"
                                  (fn [] (sum-selected-durations)) {:range true})

(vim.filetype.add {:extension {:timelog "timelog"}})

(vim.api.nvim_create_autocmd ["CursorMoved" "CursorMovedI"]
                             {:callback (fn [] (check-current-line))
                              :group (vim.api.nvim_create_augroup "TimetrackingVirtualText"
                                                                  {:clear true})})

(fn no-op [])
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "timelog"
                              :callback (fn []
                                          (vim.keymap.set "n" "<leader>d" no-op
                                                          {:buffer true})
                                          (vim.keymap.set "n" "€tb"
                                                          append-new-task
                                                          {:buffer true
                                                           :desc "Start a new task"})
                                          (vim.keymap.set "n" "€te"
                                                          close-running-task
                                                          {:buffer true
                                                           :desc "Stop the current task"})
                                          (vim.keymap.set "n" "<cr>"
                                                          append-new-task-with-current-message
                                                          {:buffer true
                                                           :desc "Switch to this task"}))})
