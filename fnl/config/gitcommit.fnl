(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "gitcommit"
                              :callback (fn []
                                          (set vim.opt_local.textwidth 72)
                                          (set vim.opt_local.colorcolumn
                                               "51,73"))})
