(vim.api.nvim_create_augroup "SessionLoad" {:clear true})
(vim.api.nvim_create_autocmd ["SessionLoadPost"]
                             {:pattern "*"
                              :group "SessionLoad"
                              :callback (fn []
                                          (let [rename-cmd (.. "silent !tmux rename-window \" "
                                                               (vim.fs.basename vim.v.this_session)
                                                               "\"")]
                                            (vim.cmd "silent !tmux bind t new-window -c $(pwd)")
                                            (vim.cmd rename-cmd)))})
