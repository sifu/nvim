-- [nfnl] Compiled from fnl/plugins/colorizer.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local colorizer = require("colorizer")
  return colorizer.setup({"css"}, {mode = "background"})
end
return {"norcalli/nvim-colorizer.lua", event = "VeryLazy", config = _1_}
