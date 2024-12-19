-- [nfnl] Compiled from fnl/plugins/dbee.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local dbee = require("dbee")
  return dbee.install("go")
end
return {"kndndrj/nvim-dbee", cmd = "Dbee", dependencies = {"MunifTanjim/nui.nvim"}, build = _1_, config = true}
