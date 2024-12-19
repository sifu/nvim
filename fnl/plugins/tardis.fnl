{1 "fredeeb/tardis.nvim"
 :cmd "Tardis"
 :dependencies ["nvim-lua/plenary.nvim"]
 :opts {:keymap {:next "<C-j>"
                 :prev "<C-k>"
                 :quit "q"
                 :revision_message "<C-m>"
                 :commit "<C-g>"}
        :initial_revisions 10
        :max_revisions 256}}
