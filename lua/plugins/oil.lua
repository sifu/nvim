-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local oil = require("oil")
  local function _2_()
    local oil0 = require("oil")
    return oil0.close()
  end
  local function _3_()
    local oil0 = require("oil")
    return oil0.set_columns({"icon", "permissions", "size", "mtime"})
  end
  local function _4_()
    return true
  end
  local function _5_()
    return true
  end
  local function _6_()
    return true
  end
  return oil.setup({columns = {"icon"}, delete_to_trash = true, watch_for_changes = true, skip_confirm_for_simple_edits = true, constrain_cursor = "name", view_options = {show_hidden = true}, keymaps = {["<esc>"] = _2_, gd = _3_, ["g:"] = {"actions.open_cmdline", desc = "Open cmdline with current directory as an argument", opts = {shorten_path = true, modify = ":h"}}}, git = {add = _4_, mv = _5_, rm = _6_}, float = {padding = 4, max_width = 0, max_height = 0, border = "rounded", win_options = {winblend = 0}}})
end
return {{"stevearc/oil.nvim", config = _1_}}
