(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

; fixjson: `yarn global add fixjson`

(local prettier {1 "prettierd" 2 "prettier" :stop_after_first true})

; Projects that configure oxc's formatter run `oxfmt --write` (lint-staged, yarn
; format), so formatting them with prettier on save silently fights them. Pick
; oxfmt (resolved from node_modules by conform) wherever a config is present.
(local oxfmt-configs [".oxfmtrc.json" ".oxfmtrc.jsonc" "oxfmt.config.ts"])

(fn oxfmt-project? [bufnr]
  (let [bufname (vim.api.nvim_buf_get_name bufnr)
        from (if (= bufname "") (vim.fn.getcwd) (vim.fs.dirname bufname))]
    (not= nil (. (vim.fs.find oxfmt-configs {:path from :upward true :limit 1})
                 1))))

(fn oxfmt-or [formatters]
  (fn [bufnr]
    (if (oxfmt-project? bufnr) ["oxfmt"] formatters)))

{1 "stevearc/conform.nvim"
 :event ["BufWritePre"]
 :cmd ["ConformInfo"]
 :opts {:formatters_by_ft {:lua ["stylua"]
                           :fennel ["fnlfmt"]
                           :json (oxfmt-or ["fixjson"])
                           :css (oxfmt-or prettier)
                           :typescript (oxfmt-or prettier)
                           :typescriptreact (oxfmt-or prettier)
                           :javascriptreact (oxfmt-or prettier)
                           :javascript (oxfmt-or prettier)
                           :sql ["sqruff"]}
        :default_format_opts {:lsp_format "fallback"}
        :format_on_save {:timeout_ms 2500}
        :formatters {:shfmt {:prepend_args ["-i" "2"]}
                     :fixjson {:prepend_args ["-w"]}}}
 :init (fn []
         (core.assoc vim.o "formatexpr" "v:lua.require'conform'.formatexpr()"))}
