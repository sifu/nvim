-- [nfnl] fnl/plugins/lsp.fnl
local function _1_()
  return require("config.lsp")
end
return {"hrsh7th/cmp-nvim-lsp", config = _1_}
