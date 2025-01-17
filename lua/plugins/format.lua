-- [nfnl] Compiled from fnl/plugins/format.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function _2_()
  return core.assoc(vim.o, "formatexpr", "v:lua.require'conform'.formatexpr()")
end
return {"stevearc/conform.nvim", event = {"BufWritePre"}, cmd = {"ConformInfo"}, opts = {formatters_by_ft = {lua = {"stylua"}, fennel = {"fnlfmt"}, typescriptreact = {"prettierd", "prettier", stop_after_first = true}, javascriptreact = {"prettierd", "prettier", stop_after_first = true}, javascript = {"prettierd", "prettier", stop_after_first = true}}, default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 500}, formatters = {shfmt = {prepend_args = {"-i", "2"}}}}, init = _2_}
