-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  local ts = require("nvim-treesitter")
  return ts.install({"bash", "clojure", "commonlisp", "dockerfile", "fennel", "html", "java", "javascript", "typescript", "tsx", "json", "lua", "markdown", "yaml"})
end
return {"nvim-treesitter/nvim-treesitter", branch = "main", dependencies = {{"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"}}, build = ":TSUpdate", config = _1_}
