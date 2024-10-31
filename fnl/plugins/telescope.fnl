[{1 "nvim-telescope/telescope.nvim"
  :dependencies ["nvim-telescope/telescope-ui-select.nvim"
                 "nvim-lua/popup.nvim"
                 "nvim-lua/plenary.nvim"]
  :init (fn []
          (vim.keymap.set "n" "<space>f"
                          ":lua require('telescope.builtin').find_files()<CR>"
                          {:noremap true :desc "Find Files"})
          (vim.keymap.set "n" "<space>g"
                          ":lua require('telescope.builtin').live_grep()<CR>"
                          {:noremap true :desc "Live Grep"})
          (vim.keymap.set "n" "<space>b"
                          ":lua require('telescope.builtin').buffers()<CR>"
                          {:noremap true :desc "Buffers"})
          (vim.keymap.set "n" "<space>h"
                          ":lua require('telescope.builtin').help_tags()<CR>"
                          {:noremap true :desc "Help Tags"}))
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
