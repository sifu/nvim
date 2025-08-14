-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  local ts = require("nvim-treesitter.configs")
  return ts.setup({highlight = {enable = true}, indent = {enable = true}, ensure_installed = {"bash", "clojure", "commonlisp", "dockerfile", "fennel", "html", "java", "javascript", "typescript", "tsx", "json", "lua", "markdown", "yaml"}})
end
return {"nvim-treesitter/nvim-treesitter", dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"}, build = ":TSUpdate", config = _1_}
