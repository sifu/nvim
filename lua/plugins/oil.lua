-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local oil = require("oil")
  return oil.setup({columns = {}, delete_to_trash = true, watch_for_changes = true, skip_confirm_for_simple_edits = true, float = {padding = 4, max_width = 0, max_height = 0, border = "rounded", win_options = {winblend = 0}, view_options = {show_hidden = true}}})
end
return {{"stevearc/oil.nvim", config = _1_}}
