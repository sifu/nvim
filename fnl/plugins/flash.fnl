{1 "folke/flash.nvim"
 :event "VeryLazy"
 :keys [{1 "s"
         2 (fn []
             (let [flash (require "flash")] (flash.jump)))
         :mode ["n" "x" "o"]
         :desc "Flash"}
        {1 "S"
         2 (fn []
             (let [flash (require "flash")] (flash.treesitter)))
         :mode ["n" "x" "o"]
         :desc "Flash Treesitter"}]}
