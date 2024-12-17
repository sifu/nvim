{1 "AckslD/nvim-neoclip.lua"
 :dependencies ["nvim-telescope/telescope.nvim"
                {1 "kkharji/sqlite.lua" :module "sqlite"}]
 :opts {:enable_persistent_history true
        :continuous_sync true
        :keys {:telescope {:i {:select "<c-space>"
                               :paste "<cr>"
                               :paste_behind "<c-P>"}}}}}
