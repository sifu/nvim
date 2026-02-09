{1 "ibhagwan/fzf-lua"
 :dependencies ["nvim-tree/nvim-web-devicons"]
 :config (fn []
           (let [fzf (require "fzf-lua")]
             ;; Gradually add back styling options
             (fzf.setup {:winopts {:height 0.85
                                   :width 0.85
                                   :row 0.5
                                   :col 0.5
                                   :preview {:layout "flex" :flip_columns 120}}
                         :grep {:rg_glob true
                                :glob_flag "--iglob"
                                :glob_separator "  "}
                         :files {:file_ignore_patterns ["node_modules"
                                                        "lua/plugins"
                                                        "lua/config"]}
                         :buffers {:sort_lastused true}})
             ;; Register as vim.ui.select handler
             (fzf.register_ui_select)))}
