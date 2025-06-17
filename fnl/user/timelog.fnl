(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local str (autoload "nfnl.string"))

(local hourly-rate 75)

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

(fn calculate-cost [duration]
  (let [hours (/ duration 3600)] ; Convert seconds to hours
    (* hours hourly-rate)))

(fn format-duration [duration]
  (let [minutes (math.floor (/ duration 60))
        hours (math.floor (/ minutes 60))
        remaining-minutes (% minutes 60)
        parts []
        cost (calculate-cost duration)
        _ (when (> hours 0)
            (table.insert parts (.. hours "h")))
        _ (when (> remaining-minutes 0)
            (table.insert parts (.. remaining-minutes "m")))]
    (if (core.empty? parts) " 0m (0€)"
        (.. " " (table.concat parts " ") " (" (string.format "%.2f" cost)
            "€)"))))

(fn is-running? [line]
  (= 1 (length (get-timestamps line))))

(fn get-timelog-lines [lines]
  (let [result []]
    (each [_ line (ipairs lines)]
      (when (is-timelog-line? line)
        (table.insert result line)))
    result))

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
  (vim.cmd "normal! `<`>")
  ;; Jump to the visual selection to ensure marks are updated
  (let [start-pos (vim.fn.getpos "'<")
        end-pos (vim.fn.getpos "'>")
        start-line (- (. start-pos 2) 1)
        end-line (. end-pos 2)
        buf (vim.api.nvim_get_current_buf)]
    (vim.api.nvim_buf_get_lines buf start-line end-line false)))

(fn sum-durations [lines]
  (accumulate [total 0 _ line (ipairs (get-timelog-lines lines))]
    (+ total (line->duration line))))

(var popup-win-id nil)

(fn close-popup []
  (when popup-win-id
    (when (vim.api.nvim_win_is_valid popup-win-id)
      (vim.api.nvim_win_close popup-win-id true))
    (set popup-win-id nil)))

(vim.api.nvim_set_hl 0 "TimelogPopup" {:bg "White" :fg "Black"})

(fn show-popup [text]
  (close-popup)
  (let [buf (vim.api.nvim_create_buf false true)
        width (+ (length text) 4)
        height 1
        opts {:relative "cursor"
              : width
              : height
              :row -1
              :col 5
              :style "minimal"
              :border "rounded"
              :focusable false
              :noautocmd true}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false [text])
    (set popup-win-id (vim.api.nvim_open_win buf false opts))
    (vim.api.nvim_win_set_option popup-win-id "winhl" "Normal:TimelogPopup")
    (vim.defer_fn (fn []
                    (close-popup)) 4000)))

(fn sum-selected-durations []
  (vim.cmd "normal! \027")
  (vim.cmd "normal! gv")
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
                                    false [stopped-line])
        (vim.cmd "write")))))

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
        (vim.cmd "norm! G")
        (vim.cmd "write")))))

(fn append-new-task []
  (let [buf (vim.api.nvim_get_current_buf)
        [row] (vim.api.nvim_win_get_cursor 0)
        lines (vim.api.nvim_buf_get_lines buf 0 -1 false)]
    (if (core.empty? lines) ; If file is empty, just create new task
        (let [new-line (create-new-task " ")]
          (vim.api.nvim_buf_set_lines buf 0 -1 false [new-line]))
        ; Otherwise check current line and close running task
        (let [current-line (. (vim.api.nvim_buf_get_lines buf (- row 1) row
                                                          false)
                              1)]
          (when (is-timelog-line? current-line)
            (close-running-task)))) ; Always add the new task
    (let [new-line (create-new-task " ")]
      (vim.api.nvim_buf_set_lines buf -1 -1 false [new-line])
      (vim.cmd "norm! G")
      (vim.cmd "write"))))

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
                                                           :desc "Switch to this task"})
                                          (vim.keymap.set "x" "ts"
                                                          sum-selected-durations
                                                          {:buffer true
                                                           :desc "Sum selected time entries"}))})

;; always start on the last line:
(vim.api.nvim_create_autocmd "BufReadPost"
                             {:pattern "*.timelog"
                              :callback (fn []
                                          (vim.cmd "normal! G"))})
