(local ls (require "luasnip"))
(local fmt (. (require "luasnip.extras.fmt") "fmt"))
(local rep (. (require "luasnip.extras") "rep"))

(local snip ls.snippet)
(local text ls.text_node)
(local insert ls.insert_node)
(local func ls.function_node)
(local choice ls.choice_node)
(local sn ls.sn)

(fn setup [] (print "TODO: port from old config"))

;; (ls.add_snippets nil
;;                  {:all [(snip {:trig "date" :namr "Date" :dscr "Date"}
;;                               [(func (fn [] (.. "Hello" "World")) {})])]}))

{: setup}
