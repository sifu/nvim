(local cmp-srcs [{:name "nvim_lsp"}
                 {:name "nvim_lsp_signature_help"}
                 {:name "conjure"}
                 {:name "render-markdown"}
                 {:name "path"}
                 {:name "luasnip"}])

(fn formatting [entry vim-item]
  (let [completion-item (entry:get_completion_item)
        colorful-menu (require "colorful-menu")
        lspkind (require "lspkind")
        highlights-info (colorful-menu.cmp_highlights entry)]
    (if (= highlights-info nil)
        (set vim-item.abbr completion-item.label)
        (do
          (set vim-item.abbr_hl_group highlights-info.highlights)
          (set vim-item.abbr highlights-info.text)))
    (local kind ((lspkind.cmp_format {:mode "symbol_text"}) entry vim-item))
    (local strings (vim.split kind.kind "%s" {:trimempty true}))
    (set vim-item.kind (.. " " (?. strings 1) " "))
    (set vim-item.menu "")
    vim-item))

(local win-options
       {:border [" " " " " " " " " " " " " " " "]
        :scrollbar false
        :winhighlight "NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"})

{1 "hrsh7th/nvim-cmp"
 :dependencies ["hrsh7th/cmp-buffer"
                "hrsh7th/cmp-nvim-lsp"
                "hrsh7th/cmp-path"
                "hrsh7th/cmp-nvim-lsp-signature-help"
                "hrsh7th/cmp-cmdline"
                "PaterJason/cmp-conjure"
                "L3MON4D3/LuaSnip"
                "saadparwaiz1/cmp_luasnip"
                "MeanderingProgrammer/render-markdown.nvim"
                "xzbdmw/colorful-menu.nvim"
                "onsails/lspkind.nvim"]
 :config (fn []
           (let [cmp (require "cmp")
                 luasnip (require "luasnip")]
             (cmp.setup {:formatting {:format formatting}
                         :completion {:autocomplete false}
                         :window {:completion (cmp.config.window.bordered win-options)
                                  :documentation (cmp.config.window.bordered win-options)}
                         :mapping {:<Up> (cmp.mapping.select_prev_item)
                                   :<Down> (cmp.mapping.select_next_item)
                                   :<C-b> (cmp.mapping.scroll_docs (- 4))
                                   :<C-f> (cmp.mapping.scroll_docs 4)
                                   :<C-Space> (cmp.mapping (fn []
                                                             (if (cmp.visible)
                                                                 (cmp.confirm {:select true})
                                                                 "else"
                                                                 (cmp.complete))))
                                   :<C-e> (cmp.mapping.close)
                                   :<S-Tab> (cmp.mapping (fn [fallback]
                                                           (if (cmp.visible)
                                                               (cmp.select_prev_item)
                                                               (luasnip.jumpable -1)
                                                               (luasnip.jump -1)
                                                               "else"
                                                               (fallback)))
                                                         {1 "i" 2 "s"})}
                         :snippet {:expand (fn [args]
                                             (luasnip.lsp_expand args.body))}
                         :sources cmp-srcs})
             (cmp.setup.filetype "oil" {:enabled false})
             (cmp.setup.filetype "chatgpt-input" {:enabled false})
             (cmp.setup.cmdline "/"
                                {:mapping (cmp.mapping.preset.cmdline)
                                 :sources [{:name "buffer"}]})
             (cmp.setup.cmdline ":"
                                {:mapping (cmp.mapping.preset.cmdline)
                                 :sources (cmp.config.sources [{:name "path"}
                                                               {:name "cmdline"
                                                                :option {:ignore_cmds ["!"
                                                                                       "Man"]}}])})))}
