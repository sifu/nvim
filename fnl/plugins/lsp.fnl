(fn define-signs [prefix]
  (let [error (.. prefix "SignError")
        warn (.. prefix "SignWarn")
        info (.. prefix "SignInfo")
        hint (.. prefix "SignHint")]
    (vim.fn.sign_define error {:text "" :texthl error})
    (vim.fn.sign_define warn {:text "" :texthl warn})
    (vim.fn.sign_define info {:text "" :texthl info})
    (vim.fn.sign_define hint {:text "" :texthl hint})))

(define-signs "Diagnostic")

(local cmp-nvim-lsp (require "cmp_nvim_lsp"))
(local capabilities (cmp-nvim-lsp.default_capabilities))

(local vtsls-opts
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

[{1 "neovim/nvim-lspconfig" :dependencies ["williamboman/mason.nvim"]}
 {1 "williamboman/mason.nvim"
  :config (fn []
            (let [mason (require "mason")]
              (mason.setup)))}
 {1 "williamboman/mason-lspconfig.nvim"
  :dependencies ["williamboman/mason.nvim" "hrsh7th/cmp-nvim-lsp"]
  :config (fn []
            (let [mason-lspconfig (require "mason-lspconfig")
                  lspconfig (require "lspconfig")]
              (mason-lspconfig.setup {:ensure_installed ["fennel_language_server"
                                                         "vtsls"
                                                         "cssmodules_ls"
                                                         "cssls"
                                                         "tailwindcss"
                                                         "clojure_lsp"]}
                                     (lspconfig.fennel_language_server.setup {: capabilities
                                                                              :settings {:fennel {:diagnostics {:globals ["vim"]}}}})
                                     (lspconfig.vtsls.setup vtsls-opts)
                                     (lspconfig.cssmodules_ls.setup {: capabilities})
                                     (lspconfig.cssls.setup {: capabilities})
                                     (lspconfig.tailwindcss.setup {: capabilities})
                                     (lspconfig.clojure_lsp.setup {: capabilities}))))}]
