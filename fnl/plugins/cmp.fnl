(local cmp-src-menu-items {:buffer "buff"
                           :conjure "conj"
                           :nvim_lsp "lsp"
                           :luasnip "lsnp"})

(local cmp-srcs [{:name "nvim_lsp"}
                 {:name "nvim_lsp_signature_help"}
                 {:name "conjure"}
                 {:name "codeium"}
                 {:name "path"}
                 {:name "buffer"}
                 {:name "luasnip"}])

(fn has-words-before []
  (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))]
    (and (not= col 0) (= (: (: (. (vim.api.nvim_buf_get_lines 0 (- line 1) line
                                                              true)
                                  1) "sub" col
                               col) "match" "%s") nil))))

{1 "hrsh7th/nvim-cmp"
 :dependencies ["hrsh7th/cmp-buffer"
                "hrsh7th/cmp-nvim-lsp"
                "hrsh7th/cmp-path"
                "hrsh7th/cmp-nvim-lsp-signature-help"
                "hrsh7th/cmp-cmdline"
                "PaterJason/cmp-conjure"
                "L3MON4D3/LuaSnip"
                "saadparwaiz1/cmp_luasnip"
                "onsails/lspkind.nvim"]
 :config (fn []
           (let [cmp (require "cmp")
                 lspkind (require "lspkind")
                 luasnip (require "luasnip")]
             (cmp.setup {:formatting {:format (lspkind.cmp_format {:mode "symbol_text"
                                                                   :maxwidth 120
                                                                   :ellipsis_char "..."
                                                                   :symbol_map {:Codeium ""}})}
                         :window {:completion (cmp.config.window.bordered)
                                  :documentation (cmp.config.window.bordered)}
                         :mapping {:<Up> (cmp.mapping.select_prev_item)
                                   :<Down> (cmp.mapping.select_next_item)
                                   :<C-b> (cmp.mapping.scroll_docs (- 4))
                                   :<C-f> (cmp.mapping.scroll_docs 4)
                                   :<C-Space> (cmp.mapping.confirm {:select true})
                                   :<C-e> (cmp.mapping.close)
                                   :<Tab> (cmp.mapping (fn [fallback]
                                                         (if (cmp.visible)
                                                             (cmp.select_next_item)
                                                             (luasnip.expand_or_jumpable)
                                                             (luasnip.expand_or_jump)
                                                             (has-words-before)
                                                             (cmp.complete)
                                                             "else"
                                                             (fallback)))
                                                       {1 "i" 2 "s"})
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
