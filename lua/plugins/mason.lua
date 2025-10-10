-- [nfnl] fnl/plugins/mason.fnl
local function _1_()
  local mason = require("mason")
  return mason.setup({ensure_installed = {"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "tailwindcss", "clojure_lsp"}})
end
return {"williamboman/mason.nvim", config = _1_}
