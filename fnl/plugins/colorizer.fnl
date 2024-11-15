{1 "norcalli/nvim-colorizer.lua"
 :event "VeryLazy"
 :config (fn []
           (let [colorizer (require "colorizer")]
             (colorizer.setup ["css"] {:mode "background"})))}
