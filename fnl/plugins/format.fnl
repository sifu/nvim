(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

[{1 "stevearc/conform.nvim"
  :event ["BufWritePre"]
  :cmd ["ConformInfo"]
  :opts {:formatters_by_ft {:lua ["stylua"] :fennel ["fnlfmt"]}
         :default_format_opts {:lsp_format "fallback"}
         :format_on_save {:timeout_ms 500}
         :formatters {:shfmt {:prepend_args ["-i" "2"]}}}
  :init (fn []
          (core.assoc vim.o "formatexpr" "v:lua.require'conform'.formatexpr()"))}]
