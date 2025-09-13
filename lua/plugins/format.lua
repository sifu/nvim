-- [nfnl] fnl/plugins/format.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local prettier = {"prettierd", "prettier", stop_after_first = true}
local function _2_()
  return core.assoc(vim.o, "formatexpr", "v:lua.require'conform'.formatexpr()")
end
return {"stevearc/conform.nvim", event = {"BufWritePre"}, cmd = {"ConformInfo"}, opts = {formatters_by_ft = {lua = {"stylua"}, fennel = {"fnlfmt"}, json = {"fixjson"}, css = prettier, typescriptreact = prettier, javascriptreact = prettier, javascript = prettier, sql = {"sqruff"}}, default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 2500}, formatters = {shfmt = {prepend_args = {"-i", "2"}}, fixjson = {prepend_args = {"-w"}}}}, init = _2_}
