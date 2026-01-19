;; JSON-specific configuration
;; Disable quote concealment in JSON files
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "json"
                              :callback (fn []
                                          (set vim.opt_local.conceallevel 0))})

{}
