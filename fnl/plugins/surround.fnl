{1 "kylechui/nvim-surround"
 :event "VeryLazy"
 :config (fn []
           (let [surround (require "nvim-surround")]
             (surround.setup)))}
