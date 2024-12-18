-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_(args)
  local oil = require("oil")
  if ((vim.api.nvim_get_current_buf() == args.data.buf) and oil.get_cursor_entry()) then
    return oil.open_preview()
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("User", {pattern = "OilEnter", callback = vim.schedule_wrap(_1_)})
local function _3_()
  local oil = require("oil")
  return oil.close()
end
local function _4_()
  local oil = require("oil")
  return oil.set_columns({"icon", "permissions", "size", "mtime"})
end
local function _5_()
  return true
end
local function _6_()
  return true
end
local function _7_()
  return true
end
return {"stevearc/oil.nvim", opts = {columns = {"icon"}, delete_to_trash = true, watch_for_changes = true, skip_confirm_for_simple_edits = true, constrain_cursor = "name", view_options = {show_hidden = true}, keymaps = {["<esc>"] = _3_, gd = _4_, ["g:"] = {"actions.open_cmdline", desc = "Open cmdline with current directory as an argument", opts = {shorten_path = true, modify = ":h"}}}, lsp_file_methods = {enabled = true, timeout_ms = 1000, autosave_changes = false}, git = {add = _5_, mv = _6_, rm = _7_}, float = {padding = 4, max_width = 0, max_height = 0, border = "rounded", win_options = {winblend = 0}}}}
