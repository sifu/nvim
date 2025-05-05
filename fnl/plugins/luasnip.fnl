(fn setup []
  (let [ls (require "luasnip")
        supermaven (require "supermaven-nvim.completion_preview")
        snippets (require "config.snippets")]
    (ls.config.set_config {:history false
                           :updateevents "TextChanged,TextChangedI"
                           :enable_autosnippets false})
    (snippets.setup)
    (vim.keymap.set ["i" "s"] "<c-k>"
                    (fn [] (if (ls.expand_or_jumpable) (ls.expand_or_jump))
                      (if (supermaven.has_suggestion)
                          (supermaven.on_accept_suggestion_word)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-j>"
                    (fn []
                      (if (ls.jumpable -1) (ls.jump -1)))
                    {:desc "LuaSnip expand/jump" :silent true})
    (vim.keymap.set ["i" "s"] "<c-l>"
                    (fn [] (if (ls.choice_active) (ls.change_choice 1)))
                    {:desc "LuaSnip choices" :silent true})))

{1 "L3MON4D3/LuaSnip"
 :config setup
 :dependencies ["supermaven-inc/supermaven-nvim"]
 :event "VeryLazy"}
