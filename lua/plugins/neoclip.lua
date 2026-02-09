-- [nfnl] fnl/plugins/neoclip.fnl
local function _1_()
  local neoclip = require("neoclip")
  return neoclip.setup({enable_persistent_history = true, continuous_sync = true, default_register = "\"", keys = {fzf = {select = "<c-space>", paste = "<cr>", paste_behind = "<c-P>", custom = {}}}})
end
return {"AckslD/nvim-neoclip.lua", dependencies = {{"kkharji/sqlite.lua", module = "sqlite"}, "ibhagwan/fzf-lua"}, opts = {enable_persistent_history = true, continuous_sync = true, default_register = "\"", keys = {fzf = {select = "<c-space>", paste = "<cr>", paste_behind = "<c-P>", custom = {}}}}, config = _1_}
