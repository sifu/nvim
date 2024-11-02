[{1 "nvim-telescope/telescope.nvim"
  :dependencies ["nvim-telescope/telescope-ui-select.nvim"
                 "nvim-lua/popup.nvim"
                 "nvim-lua/plenary.nvim"]
  :config (fn []
            (let [telescope (require "telescope")
                  themes (require "telescope.themes")]
              (telescope.setup {:defaults {:file_ignore_patterns ["node_modules"]
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
                                :extensions {:ui-select {1 (themes.get_dropdown {})}}
                                :pickers {:find_files {:find_command ["rg"
                                                                      "--files"
                                                                      "--iglob"
                                                                      "!.git"
                                                                      "--hidden"]}}})
              (telescope.load_extension "ui-select")))}]
