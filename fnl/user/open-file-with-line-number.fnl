;; User command 'E' to open files with line:column syntax
(vim.api.nvim_create_user_command "E"
                                  (fn [opts]
                                    (let [arg opts.args
                                          parts (vim.split arg ":" true)
                                          file (. parts 1)
                                          line (or (and (. parts 2)
                                                        (tonumber (. parts 2)))
                                                   1)
                                          col (or (and (. parts 3)
                                                       (tonumber (. parts 3)))
                                                  1)]
                                      (vim.cmd (.. "edit " file))
                                      (vim.api.nvim_win_set_cursor 0 [line col])))
                                  {:nargs 1
                                   :complete "file"
                                   :desc "Open file with line:column navigation (e.g., :E file.txt:10:5)"})
