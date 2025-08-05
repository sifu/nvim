(local {: autoload} (require "nfnl.module"))

(local core (autoload "nfnl.core"))

(fn set-filetype-options [] (core.assoc vim.o "tabstop" 2)
  (core.assoc vim.o "shiftwidth" 2)
  (core.assoc vim.o "softtabstop" 2))

{1 "MeanderingProgrammer/render-markdown.nvim"
 :ft ["markdown"]
 :cmd ["RenderMarkdown"]
 :dependencies ["nvim-treesitter/nvim-treesitter"
                "nvim-tree/nvim-web-devicons"]
 :opts {:render_modes ["n" "c" "t"]
        :checkbox {:custom {:todo {:raw "[-]"
                                   :rendered "󱋭 "
                                   :highlight "RenderMarkdownCanceled"}}}
        :heading {:icons [" " " " " " " " " "]
                  :signs ["" "" "" "" ""]}}
 :config (fn [_ opts]
           (let [render-markdown (require "render-markdown")]
             (render-markdown.setup opts)
             (vim.api.nvim_create_autocmd "FileType"
                                          {:pattern "markdown"
                                           :callback set-filetype-options})))}
