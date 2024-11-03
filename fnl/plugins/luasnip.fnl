(fn setup []
  (let [ls (require "luasnip")
        _fmt (require "luasnip.extras.fmt")
        extras (require "luasnip.extras")
        fmt _fmt.fmt
        rep extras.rep
        snip ls.snippet
        text ls.text_node
        insert ls.insert_node
        func ls.function_node
        choice ls.choice_node
        sn ls.sn]
    (vim.keymap.set ["i" "s"] "<c-k>"
                    (fn [] (if (ls.expand_or_jumpable) (ls.expand_or_jump)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-j>"
                    (fn [] (if (ls.jumpable -1) (ls.jump -1)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-l>"
                    (fn [] (if (ls.choice_active) (ls.change_choice 1)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (ls.add_snippets nil
                     {:all [(snip {:trig "date" :namr "Date" :dscr "Date"}
                                  [(func (fn [] (.. "Hello" "World")) {})])]})
    (print "TODO: port from old config")))

[{1 "L3MON4D3/LuaSnip" :config setup}]
