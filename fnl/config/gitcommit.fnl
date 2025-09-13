(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "gitcommit"
                              :callback (fn []
                                          (set vim.opt_local.textwidth 72))})

