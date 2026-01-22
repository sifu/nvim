{1 "folke/noice.nvim"
 :event "VeryLazy"
 :opts {:lsp {:override {:vim.lsp.util.convert_input_to_markdown true
                         :vim.lsp.util.stylize_markdown true
                         :cmp.entry.get_documentation true}
              :hover {:opts {:border {:style "none"}}}
              :signature {:enabled true :auto_open {:enabled true}}}
        :presets {:command_palette false :lsp_doc_border true}
        :views {:cmdline_popup {:border {:style "none" :padding [1 1]}
                                :win_options {:winhighlight "NormalFloat:NormalFloat,FloatBorder:FloatBorder"}}}}
 :dependencies ["MunifTanjim/nui.nvim"]}
