; TODO: check out: https://github.com/webhooked/kanso.nvim

{1 "https://github.com/rmehri01/onenord.nvim"
 :lazy false
 :priority 1000
 :dependencies ["nvim-tree/nvim-web-devicons"]
 :config (fn []
           (let [theme (require "onenord")
                 color-module (require "onenord.colors")
                 colors (color-module.load)]
             (theme.setup {:theme "light"
                           :borders true
                           :fade_nc false
                           :styles {:comments "NONE"
                                    :strings "NONE"
                                    :keywords "NONE"
                                    :functions "NONE"
                                    :variables "NONE"
                                    :diagnostics "underline"}
                           :disable {:background false
                                     :cursorline false
                                     :eob_lines true}
                           :custom_highlights {:VimwikiLink {:fg colors.dark_blue
                                                             :gui nil}
                                               :VimwikiListTodo {:fg colors.purple}
                                               :VimwikiHeaderChar {:guibg nil}
                                               :VimwikiError {:guibg nil}
                                               :CursorLineNr {:bg "#efefef"}
                                               :LineNr {:guifg "#550055"}
                                               :Underlined {:guifg "#15729e"}
                                               :Search {:guibg "#f1f1f1"
                                                        :guifg nil}
                                               :TreesitterContextLineNumber {:bg "#eeeeee"}
                                               :TelescopePromptBorder {:fg "#e0e0e0"}
                                               :TelescopeResultsBorder {:fg "#e0e0e0"}
                                               :TelescopePreviewBorder {:fg "#e0e0e0"}
                                               :NormalFloat {:fg "#2E3440"
                                                             :bg "#FFFFFF"}
                                               :FloatBorder {:fg "#6087d7"
                                                             :bg "#FFFFFF"}
                                               :FloatTitle {:fg "#6087d7"}
                                               :RenderMarkdownH1Bg {:bg "#efefef"}
                                               :RenderMarkdownH2Bg {:bg "#efefef"}
                                               :RenderMarkdownH3Bg {:bg "#efefef"}
                                               :RenderMarkdownH4Bg {:bg "#efefef"}
                                               :RenderMarkdownH5Bg {:bg "#efefef"}
                                               :RenderMarkdownH6Bg {:bg "#efefef"}
                                               :derMarkdownCanceled {:fg "#59636e"}
                                               :Visual {:bg "#fff6d5"}
                                               :CodeiumSuggestion {:fg "#333333"
                                                                   :bg "#efefef"}}
                           :custom_colors {:bg "#ffffff"}})
             (vim.cmd "colorscheme onenord")))}
