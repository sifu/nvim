(local select-one-or-multi
       (fn [prompt-bufnr]
         (let [picker ((. (require "telescope.actions.state")
                          "get_current_picker") prompt-bufnr)
               multi (picker:get_multi_selection)]
           (if (not (vim.tbl_isempty multi))
               (do
                 ((. (require "telescope.actions") "close") prompt-bufnr)
                 (each [_ j (pairs multi)]
                   (when (not= j.path nil)
                     (vim.cmd (string.format "%s %s" "edit" j.path)))))
               ((. (require "telescope.actions") "select_default") prompt-bufnr)))))

{1 "nvim-telescope/telescope.nvim"
 :dependencies ["nvim-telescope/telescope-ui-select.nvim"
                "nvim-lua/popup.nvim"
                "nvim-lua/plenary.nvim"
                "albenisolmos/telescope-oil.nvim"
                "danielvolchek/tailiscope.nvim"
                "JoseConseco/telescope_sessions_picker.nvim"]
 :config (fn []
           (let [telescope (require "telescope")
                 actions (require "telescope.actions")
                 themes (require "telescope.themes")]
             (telescope.setup {:defaults {:file_ignore_patterns ["node_modules"
                                                                 "lua/plugins"
                                                                 "lua/config"]
                                          :path_display ["truncate"]
                                          :dynamic_preview_title true
                                          :mappings {:i {:<cr> select-one-or-multi
                                                         :<esc> actions.close
                                                         :<c-q> (+ actions.send_to_qflist
                                                                   actions.open_qflist)
                                                         :<c-f> (+ actions.send_selected_to_qflist
                                                                   actions.open_qflist)
                                                         :<tab> (+ actions.toggle_selection
                                                                   actions.move_selection_better)
                                                         :<s-tab> (+ actions.toggle_selection
                                                                     actions.move_selection_worse)
                                                         :<c-c> actions.delete_buffer
                                                         :<c-u> actions.preview_scrolling_up
                                                         :<c-d> actions.preview_scrolling_down}}
                                          :vimgrep_arguments ["rg"
                                                              "--color=never"
                                                              "--no-heading"
                                                              "--with-filename"
                                                              "--line-number"
                                                              "--column"
                                                              "--smart-case"
                                                              "--iglob"
                                                              "!.git"
                                                              "--hidden"]}
                               :extensions {:ui-select {1 (themes.get_dropdown {})}
                                            :sessions_picker {:sessions_dir (.. (vim.fn.stdpath "data")
                                                                                "/session/")}}
                               :pickers {:buffers {:theme "ivy"}
                                         :git_branches {:mappings {:i {:<cr> actions.git_switch_branch}}}
                                         :find_files {:find_command ["rg"
                                                                     "--files"
                                                                     "--iglob"
                                                                     "!fontawesome"
                                                                     "--iglob"
                                                                     "!.git"
                                                                     "--hidden"]}}})
             (telescope.load_extension "ui-select")
             (telescope.load_extension "oil")
             (telescope.load_extension "fzf")
             (telescope.load_extension "tailiscope")
             (telescope.load_extension "sessions_picker")))}
