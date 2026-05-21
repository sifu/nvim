-- [nfnl] fnl/plugins/markview.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local function set_filetype_options()
  core.assoc(vim.o, "tabstop", 2)
  core.assoc(vim.o, "shiftwidth", 2)
  return core.assoc(vim.o, "softtabstop", 2)
end
local function clear_heading_backgrounds()
  for _, n in ipairs({1, 2, 3, 4, 5, 6}) do
    local name = ("MarkviewHeading" .. n)
    local hl = vim.api.nvim_get_hl(0, {name = name, link = false})
    hl["bg"] = nil
    hl["ctermbg"] = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
  return nil
end
local function _2_()
  return vim.keymap.set("n", ",T", "<cmd>Markview toggle<cr>", {buffer = true, desc = "Toggle Markview"})
end
vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _2_})
local function _3_(_, opts)
  local markview = require("markview")
  opts.markdown.list_items.checkboxes["-"] = {text = "\243\177\139\173 ", hl = "MarkviewCheckboxCancelled"}
  markview.setup(opts)
  vim.schedule(clear_heading_backgrounds)
  local function _4_()
    return vim.schedule(clear_heading_backgrounds)
  end
  vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {callback = _4_})
  return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = set_filetype_options})
end
return {"OXY2DEV/markview.nvim", ft = {"markdown"}, cmd = {"Markview"}, dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {preview = {modes = {"n", "c", "t"}, enable_hybrid_mode = false}, markdown = {headings = {enable = true, shift_width = 0, heading_1 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading1", hl = false}, heading_2 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading2", hl = false}, heading_3 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading3", hl = false}, heading_4 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading4", hl = false}, heading_5 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading5", hl = false}, heading_6 = {style = "icon", icon = " ", icon_hl = "MarkviewHeading6", hl = false}}, code_blocks = {enable = false}, list_items = {enable = true, indent_size = 2, shift_width = 2, checkboxes = {enable = true, checked = {text = "\243\176\151\160", hl = "MarkviewCheckboxChecked"}, unchecked = {text = "\243\176\132\176", hl = "MarkviewCheckboxUnchecked"}}}}}, config = _3_}
