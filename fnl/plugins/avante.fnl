{1 "yetone/avante.nvim"
 :keys [{1 "<leader>aa" 2 "<cmd>AvanteToggle<cr>" :desc "Avante Toggle"}
        {1 "<leader>ae" 2 "<cmd>AvanteEdit<cr>" :desc "Avante Edit" :mode "v"}]
 :version false
 :opts {:provider "gemini"
        ; :claude {:disable_tools true}
        ; :gemini {:model "gemini-2.5-pro-preview-6"}
        :mappings {:diff {:ours ",co"
                          :theirs ",ct"
                          :all_theirs ",ca"
                          :both ",cb"
                          :cursor ",cc"
                          :next "]x"
                          :prev "[x"}
                   :jump {:next "]]" :prev "[["}
                   :submit {:normal "<CR>" :insert "<C-s>"}
                   :sidebar {:apply_all "A"
                             :apply_cursor "a"
                             :switch_windows "<Tab>"
                             :reverse_switch_windows "<S-Tab>"}}
        :behaviour {:auto_suggestions false}}
 :build "make"
 :dependencies ["nvim-treesitter/nvim-treesitter"
                "stevearc/dressing.nvim"
                "nvim-lua/plenary.nvim"
                "MunifTanjim/nui.nvim"
                "nvim-tree/nvim-web-devicons"
                {1 "HakonHarnes/img-clip.nvim"
                 :event "VeryLazy"
                 :opts {:default {:embed_image_as_base64 false
                                  :prompt_for_file_name false
                                  :drag_and_drop {:insert_mode true}}}}
                {1 "MeanderingProgrammer/render-markdown.nvim"
                 :opts {:file_types ["markdown" "Avante"]}
                 :ft ["markdown" "Avante"]}]}
