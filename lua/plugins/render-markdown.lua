-- [nfnl] Compiled from fnl/plugins/render-markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function set_filetype_options()
  core.assoc(vim.o, "tabstop", 2)
  core.assoc(vim.o, "shiftwidth", 2)
  return core.assoc(vim.o, "softtabstop", 2)
end
local function _2_(_, opts)
  local render_markdown = require("render-markdown")
  render_markdown.setup(opts)
  return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = set_filetype_options})
end
return {"MeanderingProgrammer/render-markdown.nvim", ft = {"markdown"}, cmd = {"RenderMarkdown"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, opts = {render_modes = true, checkbox = {custom = {todo = {raw = "[-]", rendered = "\243\177\139\173 ", highlight = "RenderMarkdownCanceled"}}}, heading = {icons = {"\239\157\170 ", "\239\157\171 ", "\239\157\172 ", "\239\157\173 ", "\239\157\174 "}, signs = {"\239\135\156", "\239\135\156", "\239\135\156", "\239\135\156", "\239\135\156"}}}, config = _2_}
