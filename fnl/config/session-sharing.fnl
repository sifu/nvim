(vim.api.nvim_create_autocmd ["CursorHold" "FocusGained"]
                             {:pattern "*"
                              :callback (fn [] (vim.cmd "rshada"))})

(vim.api.nvim_create_autocmd ["TextYankPost"]
                             {:pattern ["*"] :command "wshada"})
