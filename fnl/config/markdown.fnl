(local wk (require "which-key"))

(fn toggle-todo []
  (let [line (vim.api.nvim_get_current_line)]
    (if (string.match line "- %[.%]")
        (let [new-line (if (string.match line "- %[ %]")
                           (string.gsub line "- %[ %]" "- [x]")
                           (string.gsub line "- %[.%]" "- [ ]"))]
          (vim.api.nvim_set_current_line new-line)))))

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "markdown"
                              :callback (fn []
                                          (wk.register {:glt [toggle-todo
                                                              "Toggle Todo"]}
                                                       {:buffer 0}))})
