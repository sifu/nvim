(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

; fixjson: `yarn global add fixjson`

(local prettier {1 "prettierd" 2 "prettier" :stop_after_first true})

{1 "stevearc/conform.nvim"
 :event ["BufWritePre"]
 :cmd ["ConformInfo"]
 :opts {:formatters_by_ft {:lua ["stylua"]
                           :fennel ["fnlfmt"]
                           :json ["fixjson"]
                           :css prettier
                           :typescript prettier
                           :typescriptreact prettier
                           :javascriptreact prettier
                           :javascript prettier
                           :sql ["sqruff"]}
        :default_format_opts {:lsp_format "fallback"}
        :format_on_save {:timeout_ms 2500}
        :formatters {:shfmt {:prepend_args ["-i" "2"]}
                     :fixjson {:prepend_args ["-w"]}}}
 :init (fn []
         (core.assoc vim.o "formatexpr" "v:lua.require'conform'.formatexpr()"))}
