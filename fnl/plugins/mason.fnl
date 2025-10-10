{1 "williamboman/mason.nvim"
 :config (fn []
           (let [mason (require "mason")]
             (mason.setup {:ensure_installed ["fennel_language_server"
                                              "vtsls"
                                              "cssmodules_ls"
                                              "cssls"
                                              "tailwindcss"
                                              "clojure_lsp"]})))}
