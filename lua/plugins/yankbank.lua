-- [nfnl] Compiled from fnl/plugins/yankbank.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local yb = require("yankbank")
  return yb.setup({num_behavior = "jump", persist_type = "sqlite"})
end
return {"ptdewey/yankbank-nvim", cmd = "YankBank", dependencies = "kkharji/sqlite.lua", config = _1_}
