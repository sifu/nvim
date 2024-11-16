-- [nfnl] Compiled from fnl/plugins/render-markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local md = require("render-markdown")
  return md.setup({render_modes = true, checkbox = {custom = {todo = {raw = "[-]", rendered = "\243\177\139\173 ", highlight = "RenderMarkdownCanceled"}}}, heading = {icons = {" ", " ", " ", " ", " "}, signs = {"\239\157\170", "\239\157\171", "\239\157\172", "\239\157\173", "\239\157\174"}}})
end
return {"MeanderingProgrammer/render-markdown.nvim", ft = {"markdown"}, cmd = {"RenderMarkdown"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, config = _1_}
