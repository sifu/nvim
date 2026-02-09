-- [nfnl] fnl/plugins/fzf-lua.fnl
local function _1_()
  local fzf = require("fzf-lua")
  fzf.setup({winopts = {height = 0.85, width = 0.85, row = 0.5, col = 0.5, preview = {layout = "flex", flip_columns = 120}}, grep = {rg_glob = true, glob_flag = "--iglob", glob_separator = "  "}, files = {file_ignore_patterns = {"node_modules", "lua/plugins", "lua/config"}}, buffers = {sort_lastused = true}})
  return fzf.register_ui_select()
end
return {"ibhagwan/fzf-lua", dependencies = {"nvim-tree/nvim-web-devicons"}, config = _1_}
