[{1 "stevearc/oil.nvim"
  :config (fn []
            (vim.api.nvim_set_hl 0 "Sifu-Normal" {:bg "#ffffff"})
            (vim.api.nvim_set_hl 0 "Sifu-FloatBorder"
                                 {:bg "#ffffff" :fg "#6087d7"})
            (vim.api.nvim_set_hl 0 "Sifu-FloatTitle" {:fg "#000000"})
            (let [oil (require "oil")]
              (oil.setup {:columns ["icon"]
                          :delete_to_trash true
                          :watch_for_changes true
                          :skip_confirm_for_simple_edits true
                          :constrain_cursor "name"
                          :view_options {:show_hidden true}
                          :keymaps {:<esc> (fn []
                                             (let [oil (require "oil")]
                                               (oil.close)))
                                    :gd (fn []
                                          (let [oil (require "oil")]
                                            (oil.set_columns ["icon"
                                                              "permissions"
                                                              "size"
                                                              "mtime"])))
                                    "g:" {1 "actions.open_cmdline"
                                          :desc "Open cmdline with current directory as an argument"
                                          :opts {:shorten_path true
                                                 :modify ":h"}}}
                          :git {:add (fn [] true)
                                :mv (fn [] true)
                                :rm (fn [] true)}
                          :float {:padding 4
                                  :max_width 0
                                  :max_height 0
                                  :border "rounded"
                                  :win_options {:winblend 0
                                                :winhl "Normal:Sifu-Normal,FloatBorder:Sifu-FloatBorder,FloatTitle:Sifu-FloatTitle"}}})))}]
