-- [nfnl] fnl/plugins/format.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local prettier = {"prettierd", "prettier", stop_after_first = true}
local oxfmt_configs = {".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts"}
local function oxfmt_project_3f(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local from
  if (bufname == "") then
    from = vim.fn.getcwd()
  else
    from = vim.fs.dirname(bufname)
  end
  return (nil ~= vim.fs.find(oxfmt_configs, {path = from, upward = true, limit = 1})[1])
end
local function oxfmt_or(formatters)
  local function _3_(bufnr)
    if oxfmt_project_3f(bufnr) then
      return {"oxfmt"}
    else
      return formatters
    end
  end
  return _3_
end
local function _5_()
  return core.assoc(vim.o, "formatexpr", "v:lua.require'conform'.formatexpr()")
end
return {"stevearc/conform.nvim", event = {"BufWritePre"}, cmd = {"ConformInfo"}, opts = {formatters_by_ft = {lua = {"stylua"}, fennel = {"fnlfmt"}, json = oxfmt_or({"fixjson"}), css = oxfmt_or(prettier), typescript = oxfmt_or(prettier), typescriptreact = oxfmt_or(prettier), javascriptreact = oxfmt_or(prettier), javascript = oxfmt_or(prettier), sql = {"sqruff"}}, default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 2500}, formatters = {shfmt = {prepend_args = {"-i", "2"}}, fixjson = {prepend_args = {"-w"}}}}, init = _5_}
