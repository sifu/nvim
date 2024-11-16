-- [nfnl] Compiled from fnl/plugins/render-markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local md = require("render-markdown")
  return md.setup({render_modes = true, heading = {icons = {" ", " ", " ", " ", " "}}})
end
return {"MeanderingProgrammer/render-markdown.nvim", ft = {"markdown"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, config = _1_}
