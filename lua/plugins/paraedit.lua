-- [nfnl] Compiled from fnl/plugins/paraedit.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local paredit = require("nvim-paredit")
  return paredit.setup()
end
return {{"julienvincent/nvim-paredit", lazy = true, ft = {"clojure", "fennel", "scheme", "lisp"}, config = _1_}}
