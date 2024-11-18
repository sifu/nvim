{1 "yetone/avante.nvim"
 :event "VeryLazy"
 :lazy false
 :version false
 :opts {}
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