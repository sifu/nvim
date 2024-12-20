{1 "NeogitOrg/neogit"
 :cmd "Neogit"
 :dependencies ["nvim-lua/plenary.nvim"
                "sindrets/diffview.nvim"
                "nvim-telescope/telescope.nvim"]
 :opts {:integrations {:telescope true :diffview true}
        :graph_style "kitty"
        :kind "floating"
        :commit_editor {:kind "floating" :spell_check false}
        :sections {:recent {:folded false :hidden false}}}}
