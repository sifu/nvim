(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local ls (require "luasnip"))
(local fmt (. (require "luasnip.extras.fmt") "fmt"))
(local rep (. (require "luasnip.extras") "rep"))

(local snip ls.snippet)
(local text ls.text_node)
(local insert ls.insert_node)
(local func ls.function_node)
(local choice ls.choice_node)
(local sn ls.sn)

(local all {:date [(func (fn [] (os.date "%Y-%m-%d")))]
            :time [(func (fn [] (os.date "%H:%M")))]})

(local fennel
       {:core [(text ["(local {: autoload} (require \"nfnl.module\"))"
                      "(local core (autoload \"nfnl.core\"))"])]})

(local javascript
       {:l (fmt "{}" [(choice 1
                              [(fmt "console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {})"
                                    [(insert 1)])
                               (fmt "console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2))"
                                    [(insert 1)])])])
        :ll (fmt "{}"
                 [(choice 1
                          [(fmt "console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {})"
                                [(insert 1) (rep 1)])
                           (fmt "console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({},null, 2))"
                                [(insert 1) (rep 1)])])])})

(local filetype-snippets {: all : fennel : javascript})

(fn dict->snippet-table [dict]
  (let [result []]
    (each [k v (pairs dict)]
      (table.insert result (snip {:trig k} v)))
    result))

(fn map-value [f dict]
  (let [result {}]
    (each [k v (pairs dict)] (core.assoc result k (f v)))
    result))

(fn setup []
  (ls.add_snippets nil (map-value dict->snippet-table filetype-snippets)))

{: setup}
