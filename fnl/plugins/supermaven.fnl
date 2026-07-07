{1 "supermaven-inc/supermaven-nvim"
 :event "VeryLazy"
 :opts {:ignore_filetypes {:markdown true :TelescopePrompt true}
        :condition (fn [] (= vim.bo.buftype "prompt"))
        :color {:suggestion_color "#DC8CE2" :cterm 117}}}
