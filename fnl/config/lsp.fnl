;; Create augroup for LSP to prevent duplicate autocmds
(local lsp-augroup (vim.api.nvim_create_augroup "LspConfig" {:clear true}))

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

;; Mason bin directory
(local mason-bin (.. (vim.fn.stdpath "data") "/mason/bin"))

;; Helper function to get Mason binary path
(fn mason-cmd [bin-name]
  (.. mason-bin "/" bin-name))

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
                             {:group lsp-augroup
                              :pattern "fennel"
                              :callback (fn []
                                          (let [root-dir (find-root [".git"
                                                                     "fnl"])
                                                bufnr (vim.api.nvim_get_current_buf)
                                                clients (vim.lsp.get_clients {: bufnr
                                                                              :name "fennel_language_server"})]
                                            (when (= (length clients) 0)
                                              (vim.lsp.start {:name "fennel_language_server"
                                                              :cmd [(mason-cmd "fennel-language-server")]
                                                              :root_dir root-dir
                                                              : capabilities
                                                              :settings fennel-settings}))))})

;; TypeScript/JavaScript LSP
(vim.api.nvim_create_autocmd "FileType"
                             {:group lsp-augroup
                              :pattern ["typescript"
                                        "javascript"
                                        "typescriptreact"
                                        "javascriptreact"]
                              :callback (fn []
                                          (let [root-dir (find-root [".git"
                                                                     "package.json"
                                                                     "tsconfig.json"])
                                                bufnr (vim.api.nvim_get_current_buf)
                                                ;; Check for any vtsls client with matching root
                                                clients (vim.lsp.get_clients {:name "vtsls"})
                                                ;; Find client with matching root
                                                find-matching-client (fn [client-list]
                                                                       (var found
                                                                            nil)
                                                                       (each [_ client (ipairs client-list)
                                                                              "until" found]
                                                                         (when (= client.root_dir
                                                                                  root-dir)
                                                                           (set found
                                                                                client)))
                                                                       found)
                                                existing-client (find-matching-client clients)]
                                            (when (not existing-client)
                                              (vim.lsp.start {:name "vtsls"
                                                              :cmd [(mason-cmd "vtsls")
                                                                    "--stdio"]
                                                              :root_dir root-dir
                                                              : capabilities
                                                              :settings vtsls-settings
                                                              :on_exit (fn [code signal client_id]
                                                                         (vim.notify (.. "vtsls exited with code: "
                                                                                         (or code "nil")
                                                                                         ", signal: "
                                                                                         (or signal "nil"))
                                                                                     vim.log.levels.ERROR))}))))})

;; CSS LSP servers
(vim.api.nvim_create_autocmd "FileType"
                             {:group lsp-augroup
                              :pattern "css"
                              :callback (fn []
                                          (let [root-dir (find-root [".git"
                                                                     "package.json"])
                                                bufnr (vim.api.nvim_get_current_buf)
                                                cssls-clients (vim.lsp.get_clients {: bufnr
                                                                                    :name "cssls"})
                                                cssmodules-clients (vim.lsp.get_clients {: bufnr
                                                                                         :name "cssmodules_ls"})
                                                tailwind-clients (vim.lsp.get_clients {: bufnr
                                                                                       :name "tailwindcss"})]
                                            ;; Start cssls
                                            (when (= (length cssls-clients) 0)
                                              (vim.lsp.start {:name "cssls"
                                                              :cmd [(mason-cmd "vscode-css-language-server")
                                                                    "--stdio"]
                                                              :root_dir root-dir
                                                              : capabilities
                                                              :settings cssls-settings}))
                                            ;; Start cssmodules_ls
                                            (when (= (length cssmodules-clients) 0)
                                              (vim.lsp.start {:name "cssmodules_ls"
                                                              :cmd [(mason-cmd "cssmodules-language-server")]
                                                              :root_dir root-dir
                                                              : capabilities}))
                                            ;; Start tailwindcss
                                            (when (= (length tailwind-clients) 0)
                                              (vim.lsp.start {:name "tailwindcss"
                                                              :cmd [(mason-cmd "tailwindcss-language-server")
                                                                    "--stdio"]
                                                              :root_dir (find-root [".git"
                                                                                    "package.json"
                                                                                    "tailwind.config.js"
                                                                                    "tailwind.config.ts"])
                                                              : capabilities}))))})

;; Clojure LSP
(vim.api.nvim_create_autocmd "FileType"
                             {:group lsp-augroup
                              :pattern ["clojure" "edn"]
                              :callback (fn []
                                          (let [root-dir (find-root [".git"
                                                                     "project.clj"
                                                                     "deps.edn"
                                                                     "build.boot"
                                                                     "shadow-cljs.edn"])
                                                bufnr (vim.api.nvim_get_current_buf)
                                                clients (vim.lsp.get_clients {: bufnr
                                                                              :name "clojure_lsp"})]
                                            (when (= (length clients) 0)
                                              (vim.lsp.start {:name "clojure_lsp"
                                                              :cmd [(mason-cmd "clojure-lsp")]
                                                              :root_dir root-dir
                                                              : capabilities}))))})

{}
