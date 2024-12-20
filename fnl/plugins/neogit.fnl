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
                "nvim-telescope/telescope.nvim"]
 :opts {:integrations {:telescope true :diffview true}
        :disable_hint true
        :graph_style "kitty"
        :kind "floating"
        :commit_editor {:kind "floating" :spell_check false}
        :sections {:recent {:folded false :hidden false}}}}
