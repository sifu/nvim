{1 "arborist-ts/arborist.nvim"
 :config (fn []
           (let [arborist (require "arborist")]
             (arborist.setup {:ensure_installed ["clojure"
                                                 "commonlisp"
                                                 "fennel"]})))}
