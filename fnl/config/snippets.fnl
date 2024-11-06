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

(fn dict->snippet-table [dict]
  (let [result []]
    (each [k v (pairs dict)]
      (table.insert result (snip {:trig k} v)))
    result))

(fn setup []
  (ls.add_snippets nil
                   {:all (dict->snippet-table all)
                    :javascript (dict->snippet-table javascript)}))

{: setup}
