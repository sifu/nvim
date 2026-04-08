-- [nfnl] fnl/plugins/markview.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local function set_filetype_options()
  core.assoc(vim.o, "tabstop", 2)
  core.assoc(vim.o, "shiftwidth", 2)
  return core.assoc(vim.o, "softtabstop", 2)
end
local function _2_()
  return vim.keymap.set("n", ",T", "<cmd>Markview toggle<cr>", {buffer = true, desc = "Toggle Markview"})
end
vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _2_})
local function _3_(buffer, item)
  if (item.indent <= 0) then
    return 0
  else
    return 2
  end
end
local function _5_(_, opts)
  local markview = require("markview")
  opts.markdown.list_items.checkboxes["-"] = {text = "\243\177\139\173 ", hl = "MarkviewCheckboxCancelled"}
  markview.setup(opts)
  return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = set_filetype_options})
end
return {"OXY2DEV/markview.nvim", ft = {"markdown"}, cmd = {"Markview"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, opts = {preview = {modes = {"n", "c", "t"}, enable_hybrid_mode = false}, markdown = {headings = {enable = true, shift_width = 0, heading_1 = {style = "icon", icon = " ", hl = "MarkviewHeading1"}, heading_2 = {style = "icon", icon = " ", hl = "MarkviewHeading2"}, heading_3 = {style = "icon", icon = " ", hl = "MarkviewHeading3"}, heading_4 = {style = "icon", icon = " ", hl = "MarkviewHeading4"}, heading_5 = {style = "icon", icon = " ", hl = "MarkviewHeading5"}, heading_6 = {style = "icon", icon = " ", hl = "MarkviewHeading6"}}, code_blocks = {enable = false}, list_items = {enable = true, indent_size = 2, shift_width = _3_, checkboxes = {enable = true, checked = {text = "\243\176\151\160", hl = "MarkviewCheckboxChecked"}, unchecked = {text = "\243\176\132\176", hl = "MarkviewCheckboxUnchecked"}}}}}, config = _5_}
