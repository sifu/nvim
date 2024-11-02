-- [nfnl] Compiled from fnl/plugins/gitsigns.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local gs = require("gitsigns")
  return gs.setup({signs = {add = {text = "\226\148\131"}, change = {text = "\226\148\131"}, delete = {text = "_"}, topdelete = {text = "\226\128\190"}, changedelete = {text = "~"}, untracked = {text = "\226\148\134"}}, signs_staged = {add = {text = "\226\148\131"}, change = {text = "\226\148\131"}, delete = {text = "_"}, topdelete = {text = "\226\128\190"}, changedelete = {text = "~"}, untracked = {text = "\226\148\134"}}, signs_staged_enable = true, signcolumn = true, watch_gitdir = {follow_files = true}, auto_attach = true, current_line_blame_opts = {virt_text = true, virt_text_pos = "eol", delay = 1000, virt_text_priority = 100, use_focus = true, ignore_whitespace = false}, current_line_blame_formatter = "<author>, <author_time:%R> - <summary>", sign_priority = 6, update_debounce = 100, status_formatter = nil, max_file_length = 40000, preview_config = {border = "single", style = "minimal", relative = "cursor", row = 0, col = 1}, attach_to_untracked = false, current_line_blame = false, linehl = false, numhl = false, word_diff = false})
end
return {{"https://github.com/lewis6991/gitsigns.nvim", event = "VeryLazy", config = _1_}}
