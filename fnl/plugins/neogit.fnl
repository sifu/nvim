(vim.api.nvim_create_autocmd ["BufNew" "BufEnter" "BufWinEnter"]
                             {:pattern "*COMMIT_EDITMSG"
                              :callback (fn []
                                          (vim.keymap.set "n" "€€"
                                                          ":w<cr>:bdelete<cr>"
                                                          {:buffer true
                                                           :silent true})
                                          (vim.keymap.set "i" "€€"
                                                          "<esc>:w<cr>:bdelete<cr>"
                                                          {:buffer true
                                                           :silent true}))})

{1 "NeogitOrg/neogit"
 :cmd "Neogit"
 :dependencies ["nvim-lua/plenary.nvim"
                "sindrets/diffview.nvim"
                "ibhagwan/fzf-lua"]
 :config (fn []
           (let [neogit (require "neogit")]
             (neogit.setup {:integrations {:fzf_lua true :diffview true}
                            :disable_hint true
                            :graph_style "kitty"
                            :kind "replace"
                            :sections {:recent {:folded false :hidden false}}
                            :mappings {:status {:<esc> "Close"}}})))}
