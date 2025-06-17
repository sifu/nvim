(fn follow-redirect []
  (let [line (vim.fn.getline ".")
        col (- (vim.fn.col ".") 1) ;; Convert to 0-based indexing
        ;; Simple URL pattern
        url-pattern "https?://[^ \t\n\r\"'<>]+" ;; Find all URLs in the line
        urls []]
    ;; Find all URLs and their positions
    (var pos 0)
    (while pos
      (let [(start-idx end-idx) (string.find line url-pattern (+ pos 1))]
        (if start-idx
            (do
              (table.insert urls
                            {:start (- start-idx 1)
                             ;; Convert to 0-based
                             :end (- end-idx 1)
                             ;; Convert to 0-based
                             :url (string.sub line start-idx end-idx)})
              (set pos end-idx))
            (set pos nil))))
    ;; Find URL that contains the cursor
    (var target-url nil)
    (each [_ url-info (ipairs urls)]
      (when (and (>= col url-info.start) (<= col url-info.end))
        (set target-url url-info)))
    (if target-url
        (do
          (print (.. "Found URL: " target-url.url))
          (let [curl-cmd (.. "curl -sL -o /dev/null -w '%{url_effective}' '"
                             target-url.url "'")
                result (vim.fn.system curl-cmd)
                final-url (vim.trim result)]
            (if (and (not= final-url "") (= vim.v.shell_error 0)
                     (not= final-url target-url.url))
                (do
                  ;; Position cursor at start of URL
                  (vim.fn.setpos "." [(vim.fn.bufnr)
                                      (vim.fn.line ".")
                                      (+ target-url.start 1)
                                      0])
                  ;; Select the URL
                  (vim.cmd "normal! v")
                  (vim.fn.setpos "." [(vim.fn.bufnr)
                                      (vim.fn.line ".")
                                      (+ target-url.end 1)
                                      0])
                  ;; Replace with final URL
                  (vim.cmd (.. "normal! c" final-url))
                  (print (.. "Replaced with: " final-url)))
                (print (.. "No redirect found. Final URL: " final-url)))))
        (print "No URL found at cursor position"))))

;; Create the user command
(vim.api.nvim_create_user_command "FollowRedirect" follow-redirect
                                  {:desc "Replace URL at cursor with its redirect destination"})
