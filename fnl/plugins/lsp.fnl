(fn define-signs [prefix]
  (let [error (.. prefix "SignError")
        warn (.. prefix "SignWarn")
        info (.. prefix "SignInfo")
        hint (.. prefix "SignHint")]
    (vim.fn.sign_define error {:text "" :texthl error})
    (vim.fn.sign_define warn {:text "" :texthl warn})
    (vim.fn.sign_define info {:text "" :texthl info})
    (vim.fn.sign_define hint {:text "" :texthl hint})))

(define-signs "Diagnostic")

[{1 "williamboman/mason.nvim"
  :config (fn []
            (let [mason (require "mason")]
              (mason.setup)))}
 {1 "williamboman/mason-lspconfig.nvim"
  :dependencies ["williamboman/mason.nvim" "hrsh7th/cmp-nvim-lsp"]
  :config (fn []
            (let [mason-lspconfig (require "mason-lspconfig")
                  cmp-nvim-lsp (require "cmp_nvim_lsp")
                  capabilities (cmp-nvim-lsp.default_capabilities)]
              (mason-lspconfig.setup {:ensure_installed ["fennel_language_server"
                                                         "vtsls"
                                                         "cssmodules_ls"
                                                         "cssls"
                                                         "tailwindcss"
                                                         "clojure_lsp"]
                                      :automatic_enable false})
              ;; Configure LSP servers using modern vim.lsp.config approach
              (vim.lsp.config "fennel_language_server"
                              {: capabilities
                               :settings {:fennel {:diagnostics {:globals ["vim"]}}}})
              (vim.lsp.config "vtsls"
                              {: capabilities
                               :settings {:complete_function_calls true
                                          :vtsls {:enableMoveToFileCodeAction true}
                                          :typescript {:preferences {:importModuleSpecifier "non-relative"
                                                                     :importModuleSpecifierEnding "minimal"}
                                                       :updateImportsOnFileMove {:enabled "always"}}
                                          :suggest {:completeFunctionCalls true}
                                          :inlayHints {:enumMemberValues {:enabled true}
                                                       :functionLikeReturnTypes {:enabled true}
                                                       :parameterNames {:enabled "literals"}
                                                       :parameterTypes {:enabled true}
                                                       :propertyDeclarationTypes {:enabled true}
                                                       :variableTypes {:enabled false}}}})
              (vim.lsp.config "cssmodules_ls" {: capabilities})
              (vim.lsp.config "cssls"
                              {: capabilities
                               :settings {:css {:validate true
                                                :lint {:unknownAtRules "ignore"}}}})
              (vim.lsp.config "tailwindcss" {: capabilities})
              (vim.lsp.config "clojure_lsp" {: capabilities})
              ;; Enable LSP servers
              (vim.lsp.enable "fennel_language_server")
              (vim.lsp.enable "vtsls")
              (vim.lsp.enable "cssmodules_ls")
              (vim.lsp.enable "cssls")
              (vim.lsp.enable "tailwindcss")
              (vim.lsp.enable "clojure_lsp")
              ;; Define server configurations and their filetypes
              (local server-configs
                     {:fennel_language_server {:filetypes ["fennel"]
                                               :cmd ["fennel-language-server"]
                                               :settings {:fennel {:diagnostics {:globals ["vim"]}}}}
                      :vtsls {:filetypes ["typescript"
                                          "javascript"
                                          "typescriptreact"
                                          "javascriptreact"]
                              :cmd ["vtsls" "--stdio"]
                              :settings {:complete_function_calls true}
                              :vtsls {:enableMoveToFileCodeAction true}
                              :typescript {:preferences {:importModuleSpecifier "non-relative"
                                                         :importModuleSpecifierEnding "minimal"}
                                           :updateImportsOnFileMove {:enabled "always"}}
                              :suggest {:completeFunctionCalls true}
                              :inlayHints {:enumMemberValues {:enabled true}
                                           :functionLikeReturnTypes {:enabled true}
                                           :parameterNames {:enabled "literals"}
                                           :parameterTypes {:enabled true}
                                           :propertyDeclarationTypes {:enabled true}
                                           :variableTypes {:enabled false}}}
                      :cssls {:filetypes ["css" "scss" "less"]
                              :cmd ["vscode-css-language-server" "--stdio"]
                              :settings {:css {:validate true}
                                         :lint {:unknownAtRules "ignore"}}}
                      :cssmodules_ls {:filetypes ["typescript"
                                                  "javascript"
                                                  "typescriptreact"
                                                  "javascriptreact"]
                                      :cmd ["cssmodules-language-server"]}
                      :tailwindcss {:filetypes ["html"
                                                "css"
                                                "scss"
                                                "javascript"
                                                "javascriptreact"
                                                "typescript"
                                                "typescriptreact"
                                                "vue"
                                                "svelte"]
                                    :cmd ["tailwindcss-language-server"
                                          "--stdio"]}
                      :clojure_lsp {:filetypes ["clojure"
                                                "clojurescript"
                                                "edn"]
                                    :cmd ["clojure-lsp"]}})
              ;; Create autocommands for each server
              (each [server-name config (pairs server-configs)]
                (vim.api.nvim_create_autocmd "FileType"
                                             {:pattern config.filetypes
                                              :callback (fn []
                                                          (local server-config
                                                                 (vim.tbl_deep_extend "force"
                                                                                      {:name server-name
                                                                                       : capabilities}
                                                                                      config))
                                                          (vim.lsp.start server-config))}))))}]
