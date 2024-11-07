-- [nfnl] Compiled from fnl/plugins/lsp-signature.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_(_, opts)
  local lsp_signature = require("lsp_signature")
  return lsp_signature.setup(opts)
end
return {{"ray-x/lsp_signature.nvim", event = "VeryLazy", opts = {}, config = _1_}}
