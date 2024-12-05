-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local oil = require("oil")
  return oil.close()
end
local function _2_()
  local oil = require("oil")
  return oil.set_columns({"icon", "permissions", "size", "mtime"})
end
local function _3_()
  return true
end
local function _4_()
  return true
end
local function _5_()
  return true
end
return {"stevearc/oil.nvim", opts = {columns = {"icon"}, delete_to_trash = true, watch_for_changes = true, skip_confirm_for_simple_edits = true, constrain_cursor = "name", view_options = {show_hidden = true}, keymaps = {["<esc>"] = _1_, gd = _2_, ["g:"] = {"actions.open_cmdline", desc = "Open cmdline with current directory as an argument", opts = {shorten_path = true, modify = ":h"}}}, git = {add = _3_, mv = _4_, rm = _5_}, float = {padding = 4, max_width = 0, max_height = 0, border = "rounded", win_options = {winblend = 0}}}}
