{1 "MeanderingProgrammer/render-markdown.nvim"
 :ft ["markdown"]
 :cmd ["RenderMarkdown"]
 :dependencies ["nvim-treesitter/nvim-treesitter"
                "nvim-tree/nvim-web-devicons"]
 :config (fn []
           (let [md (require "render-markdown")]
             (md.setup {:render_modes true
                        :checkbox {:custom {:todo {:raw "[-]"
                                                   :rendered "󱋭 "
                                                   ; 
                                                   :highlight "RenderMarkdownCanceled"}}}
                        :heading {:icons [" " " " " " " " " "]
                                  :signs ["" "" "" "" ""]}})))}
