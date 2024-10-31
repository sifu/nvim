-- [nfnl] Compiled from fnl/plugins/codeium.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local codeium = require("codeium")
  return codeium.setup()
end
return {{"Exafunction/codeium.nvim", event = "VeryLazy", config = _1_}}
