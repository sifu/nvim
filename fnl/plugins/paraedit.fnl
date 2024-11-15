{1 "julienvincent/nvim-paredit"
 :lazy true
 :ft ["clojure" "fennel" "scheme" "lisp"]
 :config (fn []
           (let [paredit (require "nvim-paredit")]
             (paredit.setup)))}
