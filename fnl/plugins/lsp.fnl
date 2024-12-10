;; TODO: use https://github.com/pmizio/typescript-tools.nvim/ instead of ts_ls
;; and for auto imports (if not possible to do it for word-under-cursor):
;; vim.api.nvim_create_autocmd("BufWritePre", {
;;  group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
;;  desc = "TS_add_missing_imports",
;;  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
;;  callback = function()
;;    vim.cmd([[TSToolsAddMissingImports]])
;;    vim.cmd("write")
;;  end,

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

(local fennel-opts {:settings {:fennel {:diagnostics {:globals ["vim"]}}}})

[{1 "neovim/nvim-lspconfig" :dependencies ["williamboman/mason.nvim"]}
 {1 "williamboman/mason.nvim"
  :config (fn []
            (let [mason (require "mason")]
              (mason.setup)))}
 {1 "williamboman/mason-lspconfig.nvim"
  :dependencies ["williamboman/mason.nvim"]
  :config (fn []
            (let [mason-lspconfig (require "mason-lspconfig")
                  lspconfig (require "lspconfig")]
              (mason-lspconfig.setup {:ensure_installed ["fennel_language_server"
                                                         "ts_ls"
                                                         "cssmodules_ls"
                                                         "cssls"
                                                         "clojure_lsp"]}
                                     (lspconfig.fennel_language_server.setup fennel-opts)
                                     (lspconfig.ts_ls.setup {:init_options {:hostInfo "Neovim"
                                                                            :preferences {:importModuleSpecifierPreference "non-relative"}}})
                                     (lspconfig.cssmodules_ls.setup {})
                                     (lspconfig.cssls.setup {})
                                     (lspconfig.clojure_lsp.setup {}))))}]
