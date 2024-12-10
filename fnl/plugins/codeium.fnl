;; TODO: try https://github.com/monkoose/neocodeium instead

{1 "Exafunction/codeium.nvim"
 :event "VeryLazy"
 :config (fn []
           (let [codeium (require "codeium")]
             (codeium.setup)))}
