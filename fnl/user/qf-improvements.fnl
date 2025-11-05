;; disable our default <enter> key mapping in the quickfix window
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "qf"
                              :callback (fn []
                                          (pcall vim.keymap.del "n" "<enter>"))})

(fn remove-qf-item []
  (let [curqfidx (vim.fn.line ".")
        qfall (vim.fn.getqflist)]
    (when (> (length qfall) 0)
      (table.remove qfall curqfidx)
      (vim.fn.setqflist qfall "r")
      (vim.cmd "copen")
      (let [new-idx (if (< curqfidx (length qfall))
                        curqfidx
                        (math.max (- curqfidx 1) 1))
            winid (vim.fn.win_getid)]
        (vim.api.nvim_win_set_cursor winid [new-idx 0])))))

(vim.cmd "command! RemoveQFItem lua require('fennel').eval('(remove-qf-item)')")

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "qf"
                              :callback (fn []
                                          (vim.keymap.set "n" "dd"
                                                          remove-qf-item
                                                          {:buffer true
                                                           :silent true
                                                           :noremap true}))})
