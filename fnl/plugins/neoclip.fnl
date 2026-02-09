{1 "AckslD/nvim-neoclip.lua"
 :dependencies [{1 "kkharji/sqlite.lua" :module "sqlite"} "ibhagwan/fzf-lua"]
 :opts {:enable_persistent_history true
        :continuous_sync true
        :default_register "\""
        :keys {:fzf {:select "<c-space>"
                     :paste "<cr>"
                     :paste_behind "<c-P>"
                     :custom {}}}}
 :config (fn []
           (let [neoclip (require "neoclip")]
             (neoclip.setup {:enable_persistent_history true
                             :continuous_sync true
                             :default_register "\""
                             :keys {:fzf {:select "<c-space>"
                                          :paste "<cr>"
                                          :paste_behind "<c-P>"
                                          :custom {}}}})))}
