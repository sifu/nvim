-- [nfnl] Compiled from fnl/plugins/telescope-undo.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local telescope = require("telescope")
  return telescope.load_extension("undo")
end
return {{"debugloop/telescope-undo.nvim", dependencies = {"nvim-telescope/telescope.nvim"}, keys = {{"<leader>u", "<cmd>Telescope undo<cr>", "Undo Tree"}}, config = _1_}}
