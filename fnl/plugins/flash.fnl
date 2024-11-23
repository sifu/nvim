{1 "folke/flash.nvim"
 :event "VeryLazy"
 :opts {:modes {:search {:enabled true}}}
 :keys [{1 "s"
         2 (fn []
             (let [flash (require "flash")] (flash.jump)))
         :mode ["n" "x" "o"]
         :desc "Flash"}
        {1 "S"
         2 (fn []
             (let [flash (require "flash")] (flash.treesitter)))
         :mode ["n" "x" "o"]
         :desc "Flash Treesitter"}
        {1 "r"
         2 (fn []
             (let [flash (require "flash")] (flash.remote)))
         :mode ["o"]
         :desc "Flash Remote"}
        {1 "R"
         2 (fn []
             (let [flash (require "flash")] (flash.treesitter_search)))
         :mode ["o"]
         :desc "Flash Treesitter Search"}
        {1 "<c-s>"
         2 (fn []
             (let [flash (require "flash")] (flash.toggle)))
         :mode ["c"]
         :desc "Toggle Flash Search"}]}
