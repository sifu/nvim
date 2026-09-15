(fn toggle []
  (let [api (require "supermaven-nvim.api")]
    (api.toggle)
    (vim.notify (.. "Supermaven " (if (api.is_running) "enabled" "disabled")))))

{1 "supermaven-inc/supermaven-nvim"
 :event "VeryLazy"
 :keys [{1 "<leader>aa" 2 toggle :desc "Toggle AI Completion"}]
 :opts {:ignore_filetypes {:markdown true :TelescopePrompt true}
        :condition (fn [] (= vim.bo.buftype "prompt"))
        :color {:suggestion_color "#DC8CE2" :cterm 117}}}
