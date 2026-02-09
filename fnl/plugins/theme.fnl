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
                           :borders false
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
                                               :NormalFloat {:fg "#2E3440"
                                                             :bg "#efefef"}
                                               :FloatBorder {:fg "#efefef"
                                                             :bg "#efefef"}
                                               :FloatTitle {:fg colors.purple
                                                            :bg "#efefef"}
                                               ;; fzf-lua uses similar highlight groups
                                               :FzfLuaNormal {:bg "#efefef"}
                                               :FzfLuaBorder {:bg "#eeeeee"
                                                              :fg "#000000"}
                                               :FzfLuaPreviewNormal {:bg "#dedede"}
                                               :FzfLuaPreviewBorder {:fg "#e0e0e0"
                                                                     :bg "#dedede"}
                                               :FzfLuaTitle {:fg colors.purple}
                                               ;; Keep Telescope theme for TodoTelescope and any extensions
                                               :TelescopeNormal {:bg "#efefef"}
                                               :TelescopeBorder {:bg "#eeeeee"
                                                                 :fg "#000000"}
                                               :TelescopePromptNormal {:bg "#cccccc"}
                                               :TelescopeResultsNormal {:bg "#efefef"}
                                               :TelescopePreviewNormal {:bg "#dedede"}
                                               :TelescopePromptBorder {:fg "#000000"
                                                                       :bg "#cccccc"}
                                               :TelescopeResultsBorder {:fg "#e0e0e0"
                                                                        :bg "#efefef"}
                                               :TelescopePreviewBorder {:fg "#e0e0e0"
                                                                        :bg "#dedede"}
                                               :TelescopeResultsTitle {:bg "#efefef"
                                                                       :fg colors.purple}
                                               :TelescopePromptTitle {:bg "#cccccc"
                                                                      :fg colors.purple}
                                               :TelescopePreviewTitle {:bg "#dedede"
                                                                       :fg colors.purple}
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
