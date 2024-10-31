(let [normal-mode-mappings [{:key "<Tab>" :map ":bn<cr>" :desc "Next Buffer"}
                            {:key "<s-Tab>"
                             :map ":bp<cr>"
                             :desc "Previous Buffer"}
                            {:key "U" :map ":redo<cr>" :desc "Redo"}
                            {:key "gf"
                             :map ":e <cfile><cr>"
                             :desc "Open file under cursor"}
                            {:key ",,"
                             :map ":e#<cr>"
                             :desc "Switch between alternate buffers"}
                            {:key "<leader>w"
                             :map "<C-w>"
                             :desc "Window movements"}
                            {:key "˙"
                             :map "<C-W><C-H>"
                             :desc "Window movements"}
                            {:key "¬"
                             :map "<C-W><C-L>"
                             :desc "Window movements"}
                            {:key "∆"
                             :map "<C-W><C-J>"
                             :desc "Window movements"}
                            {:key "˚"
                             :map "<C-W><C-K>"
                             :desc "Window movements"}
                            {:key "ø"
                             :map "<C-W><C-O>"
                             :desc "Window movements"}
                            {:key "ß"
                             :map "<C-W><C-S>"
                             :desc "Window movements"}
                            {:key "√"
                             :map "<C-W><C-V>"
                             :desc "Window movements"}]]
  (each [_ entry (ipairs normal-mode-mappings)]
    (vim.keymap.set "n" (. entry "key") (. entry "map")
                    {:noremap true :desc (. entry "desc")})))
