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

(local cssls-opts
       {: capabilities
        :settings {:css {:validate true :lint {:unknownAtRules "ignore"}}}})

[{1 "neovim/nvim-lspconfig" :dependencies ["williamboman/mason.nvim"]}
 {1 "williamboman/mason.nvim"
  :config (fn []
            (let [mason (require "mason")]
              (mason.setup)))}
 {1 "williamboman/mason-lspconfig.nvim"
  :dependencies ["williamboman/mason.nvim" "hrsh7th/cmp-nvim-lsp"]
  :config (fn []
            (let [mason-lspconfig (require "mason-lspconfig")]
              (mason-lspconfig.setup {:ensure_installed ["fennel_language_server"
                                                         "vtsls"
                                                         "cssmodules_ls"
                                                         "cssls"
                                                         "tailwindcss"
                                                         "clojure_lsp"]})
              ;; Configure language servers using vim.lsp.config() and vim.lsp.enable()
              (vim.lsp.config "fennel_language_server"
                              {: capabilities
                               :settings {:fennel {:diagnostics {:globals ["vim"]}}}})
              (vim.lsp.enable "fennel_language_server")
              (vim.lsp.config "vtsls" vtsls-opts)
              (vim.lsp.enable "vtsls")
              (vim.lsp.config "cssmodules_ls" {: capabilities})
              (vim.lsp.enable "cssmodules_ls")
              (vim.lsp.config "cssls" cssls-opts)
              (vim.lsp.enable "cssls")
              (vim.lsp.config "tailwindcss" {: capabilities})
              (vim.lsp.enable "tailwindcss")
              (vim.lsp.config "clojure_lsp" {: capabilities})
              (vim.lsp.enable "clojure_lsp")))}]
