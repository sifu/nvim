(local env-path "/s/.claude/.trello.env")

(var credentials nil)

(fn read-credentials []
  "Read TRELLO_KEY/TRELLO_TOKEN from the env file, cached after first read."
  (when (not credentials)
    (let [f (io.open env-path "r")]
      (when f
        (let [content (f:read "*a")]
          (f:close)
          (let [key (string.match content "TRELLO_KEY=%s*([^%s]+)")
                token (string.match content "TRELLO_TOKEN=%s*([^%s]+)")]
            (when (and key token)
              (set credentials {: key : token})))))))
  credentials)

(fn shortlink-on-line [line]
  "Extract the Trello card shortlink from a [Trello](https://trello.com/c/<id>/…) line."
  (let [url (string.match line "%[Trello%]%((.-)%)")]
    (when url
      (string.match url "trello%.com/c/(%w+)"))))

;; floating window handling --------------------------------------------------

(var win-id nil)

(fn close []
  (when (and win-id (vim.api.nvim_win_is_valid win-id))
    (vim.api.nvim_win_close win-id true))
  (set win-id nil))

(fn open-popup [lines]
  (close)
  (let [buf (vim.api.nvim_create_buf false true)
        ui (. (vim.api.nvim_list_uis) 1)
        width (math.min (math.max 60 (- ui.width 20)) 100)
        ;; account for wrapping: a long line occupies several visual rows
        content-height (accumulate [h 0 _ l (ipairs lines)]
                         (+ h (math.max 1 (math.ceil (/ (length l) width)))))
        height (math.min (math.max 12 content-height) (- ui.height 6))
        opts {:relative "editor"
              : width
              : height
              :row (math.floor (/ (- ui.height height) 2))
              :col (math.floor (/ (- ui.width width) 2))
              :style "minimal"
              :border "rounded"
              :title " Trello "
              :title_pos "center"}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (vim.api.nvim_set_option_value "modifiable" false {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.api.nvim_set_option_value "filetype" "markdown" {: buf})
    (set win-id (vim.api.nvim_open_win buf true opts))
    (vim.api.nvim_set_option_value "wrap" true {:win win-id})
    (vim.api.nvim_set_option_value "linebreak" true {:win win-id})
    (vim.keymap.set "n" "q" close {:buffer buf :nowait true :silent true})
    (vim.keymap.set "n" "<esc>" close {:buffer buf :nowait true :silent true})
    (vim.api.nvim_create_autocmd "BufLeave"
                                 {:buffer buf :once true :callback close})))

;; card rendering ------------------------------------------------------------

(fn card->lines [card]
  (let [list-name (or (?. card "list" "name") "(no list)")
        members (icollect [_ m (ipairs (or card.members []))]
                  m.fullName)
        lines [list-name
               (string.rep "─" (math.max 12 (length list-name)))
               (or card.name "(untitled)")
               ""]]
    (table.insert lines (.. "Members: "
                            (if (> (length members) 0)
                                (table.concat members ", ")
                                "—")))
    (when (and card.desc (not= card.desc ""))
      (table.insert lines "")
      (each [line (string.gmatch (.. card.desc "\n") "(.-)\n")]
        (table.insert lines line)))
    lines))

(fn fetch-and-show [shortlink creds]
  (let [url (.. "https://api.trello.com/1/cards/" shortlink
                "?fields=name,desc&list=true"
                "&members=true&member_fields=fullName" "&key=" creds.key
                "&token=" creds.token)
        chunks []]
    (vim.notify "Trello: fetching card…" vim.log.levels.INFO)
    (vim.fn.jobstart ["curl" "-s" url]
                     {:stdout_buffered true
                      :on_stdout (fn [_ data _]
                                   (when data
                                     (each [_ d (ipairs data)]
                                       (table.insert chunks d))))
                      :on_exit (fn [_ code _]
                                 (vim.schedule (fn []
                                                 (if (not= code 0)
                                                     (vim.notify (.. "Trello: curl failed (exit "
                                                                     code ")")
                                                                 vim.log.levels.ERROR)
                                                     (let [body (table.concat chunks
                                                                              "\n")
                                                           (ok card) (pcall vim.json.decode
                                                                            body)]
                                                       (if (and ok
                                                                (= (type card)
                                                                   "table")
                                                                card.name)
                                                           (open-popup (card->lines card))
                                                           (vim.notify (.. "Trello: "
                                                                           body)
                                                                       vim.log.levels.WARN)))))))})))

(fn show-card-info []
  (let [line (vim.api.nvim_get_current_line)
        shortlink (shortlink-on-line line)]
    (if (not shortlink)
        (vim.notify "No [Trello](…) link on this line" vim.log.levels.WARN)
        (let [creds (read-credentials)]
          (if (not creds)
              (vim.notify (.. "Trello: missing credentials in " env-path)
                          vim.log.levels.ERROR)
              (fetch-and-show shortlink creds))))))

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "markdown"
                              :callback (fn []
                                          (vim.keymap.set "n" ",ct"
                                                          show-card-info
                                                          {:buffer true
                                                           :silent true
                                                           :desc "Trello card info"}))})

{: show-card-info}
