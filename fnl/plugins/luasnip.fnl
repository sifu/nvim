(fn setup []
  (let [ls (require "luasnip")
        snippets (require "config.snippets")]
    (vim.keymap.set ["i" "s"] "<c-k>"
                    (fn [] (if (ls.expand_or_jumpable) (ls.expand_or_jump)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-j>"
                    (fn [] (if (ls.jumpable -1) (ls.jump -1)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-l>"
                    (fn [] (if (ls.choice_active) (ls.change_choice 1)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (snippets.setup)))

[{1 "L3MON4D3/LuaSnip" :config setup}]
