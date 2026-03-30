(vim.diagnostic.config {:signs {:text {vim.diagnostic.severity.ERROR ""
                                       vim.diagnostic.severity.WARN ""
                                       vim.diagnostic.severity.INFO ""
                                       vim.diagnostic.severity.HINT ""}}})

(local vtsls-settings
       {:complete_function_calls true
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
                     :variableTypes {:enabled false}}})

(local cssls-settings {:css {:validate true :lint {:unknownAtRules "ignore"}}})

[{1 "williamboman/mason.nvim"
  :config (fn []
            (let [mason (require "mason")]
              (mason.setup)))}
 {1 "williamboman/mason-lspconfig.nvim"
  :dependencies ["williamboman/mason.nvim"]
  :config (fn []
            (let [mason-lspconfig (require "mason-lspconfig")]
              (mason-lspconfig.setup {:ensure_installed ["fennel_language_server"
                                                         "vtsls"
                                                         "cssmodules_ls"
                                                         "cssls"
                                                         "html"
                                                         "eslint"
                                                         "tailwindcss"
                                                         "clojure_lsp"]})))}
 {1 "neovim/nvim-lspconfig"
  :dependencies ["williamboman/mason.nvim"
                 "williamboman/mason-lspconfig.nvim"
                 "hrsh7th/cmp-nvim-lsp"]
  :config (fn []
            (let [cmp-nvim-lsp (require "cmp_nvim_lsp")
                  capabilities (cmp-nvim-lsp.default_capabilities)]
              (vim.lsp.config "fennel_language_server"
                              {: capabilities
                               :settings {:fennel {:diagnostics {:globals ["vim"]}}}})
              (vim.lsp.config "vtsls" {: capabilities :settings vtsls-settings})
              (vim.lsp.config "cssmodules_ls" {: capabilities})
              (vim.lsp.config "cssls" {: capabilities :settings cssls-settings})
              (vim.lsp.config "tailwindcss" {: capabilities})
              (vim.lsp.config "html" {: capabilities})
              (vim.lsp.config "eslint" {: capabilities})
              (vim.lsp.config "clojure_lsp" {: capabilities})
              (vim.lsp.enable ["fennel_language_server"
                               "vtsls"
                               "cssmodules_ls"
                               "cssls"
                               "tailwindcss"
                               "html"
                               "eslint"
                               "clojure_lsp"])))}]
