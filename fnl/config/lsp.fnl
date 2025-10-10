;; Define diagnostic signs
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

;; Get capabilities from cmp-nvim-lsp
(local cmp-nvim-lsp (require "cmp_nvim_lsp"))
(local capabilities (cmp-nvim-lsp.default_capabilities))

;; Helper function to find project root
(fn find-root [markers]
  (let [bufpath (vim.api.nvim_buf_get_name 0)
        found (vim.fs.find markers {:upward true :path bufpath})]
    (if (> (length found) 0)
        (vim.fs.dirname (. found 1))
        (vim.fs.dirname bufpath))))

;; Server configurations
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

(local fennel-settings {:fennel {:diagnostics {:globals ["vim"]}}})

;; Start LSP servers using vim.lsp.start()

;; Fennel LSP
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "fennel"
                              :callback (fn []
                                          (vim.lsp.start {:name "fennel_language_server"
                                                          :cmd ["fennel-language-server"]
                                                          :root_dir (find-root [".git"
                                                                                "fnl"])
                                                          : capabilities
                                                          :settings fennel-settings}))})

;; TypeScript/JavaScript LSP
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern ["typescript"
                                        "javascript"
                                        "typescriptreact"
                                        "javascriptreact"]
                              :callback (fn []
                                          (vim.lsp.start {:name "vtsls"
                                                          :cmd ["vtsls"
                                                                "--stdio"]
                                                          :root_dir (find-root [".git"
                                                                                "package.json"
                                                                                "tsconfig.json"])
                                                          : capabilities
                                                          :settings vtsls-settings}))})

;; CSS LSP servers
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "css"
                              :callback (fn []
                                          ;; Start cssls
                                          (vim.lsp.start {:name "cssls"
                                                          :cmd ["vscode-css-language-server"
                                                                "--stdio"]
                                                          :root_dir (find-root [".git"
                                                                                "package.json"])
                                                          : capabilities
                                                          :settings cssls-settings})
                                          ;; Start cssmodules_ls
                                          (vim.lsp.start {:name "cssmodules_ls"
                                                          :cmd ["cssmodules-language-server"]
                                                          :root_dir (find-root [".git"
                                                                                "package.json"])
                                                          : capabilities})
                                          ;; Start tailwindcss
                                          (vim.lsp.start {:name "tailwindcss"
                                                          :cmd ["tailwindcss-language-server"
                                                                "--stdio"]
                                                          :root_dir (find-root [".git"
                                                                                "package.json"
                                                                                "tailwind.config.js"
                                                                                "tailwind.config.ts"])
                                                          : capabilities}))})

;; Clojure LSP
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern ["clojure" "edn"]
                              :callback (fn []
                                          (vim.lsp.start {:name "clojure_lsp"
                                                          :cmd ["clojure-lsp"]
                                                          :root_dir (find-root [".git"
                                                                                "project.clj"
                                                                                "deps.edn"
                                                                                "build.boot"
                                                                                "shadow-cljs.edn"])
                                                          : capabilities}))})

{}
