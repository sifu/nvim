-- [nfnl] Compiled from fnl/plugins/telescope-import.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local telescope = require("telescope")
  return telescope.load_extension("import")
end
return {"piersolenski/telescope-import.nvim", dependencies = {"nvim-telescope/telescope.nvim"}, config = _1_}
