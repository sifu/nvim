(vim.api.nvim_create_autocmd "User"
                             {:pattern "OilEnter"
                              :callback (vim.schedule_wrap (fn [args]
                                                             (let [oil (require "oil")]
                                                               (when (and (= (vim.api.nvim_get_current_buf)
                                                                             args.data.buf)
                                                                          (oil.get_cursor_entry))
                                                                 (oil.open_preview)))))})

{1 "stevearc/oil.nvim"
 :opts {:columns ["icon"]
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
                        :opts {:shorten_path true :modify ":h"}}}
        :lsp_file_methods {:enabled true
                           :timeout_ms 1000
                           :autosave_changes false}
        :git {:add (fn [] true) :mv (fn [] true) :rm (fn [] true)}
        :float {:padding 4
                :max_width 0
                :max_height 0
                :border "rounded"
                :win_options {:winblend 0}}}}
