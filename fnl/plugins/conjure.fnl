{1 "Olical/conjure"
 :ft ["fennel" "clojure"]
 :branch "main"
 :init (fn []
         (set vim.g.conjure#mapping#prefix "€c")
         (set vim.g.conjure#mapping#doc_word "K")
         (set vim.g.conjure#client#clojure#nrepl#eval#auto_require false)
         (set vim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled
              false))}
