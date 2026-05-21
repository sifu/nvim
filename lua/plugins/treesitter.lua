-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  local arborist = require("arborist")
  return arborist.setup({ensure_installed = {"clojure", "commonlisp", "fennel"}})
end
return {"arborist-ts/arborist.nvim", config = _1_}
