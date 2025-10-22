; No idea why I had this in my config, this disabled the automatic starting of a babashka repl
; (set vim.g.conjure#client#clojure#nrepl#eval#auto_require false)
; (set vim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled
;      false))}

{1 "Olical/conjure"
 :ft ["fennel" "clojure" "janet" "javascript"]
 :branch "main"
 :init (fn []
         (set vim.g.conjure#mapping#prefix ",")
         (set vim.g.conjure#mapping#doc_word "K"))}
