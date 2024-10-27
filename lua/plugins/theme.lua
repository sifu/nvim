-- [nfnl] Compiled from fnl/plugins/theme.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local theme = require("tokyonight")
  local function _2_(colors)
    colors.bg = "#ffffff"
    return nil
  end
  theme.setup({style = "night", styles = {comments = {italic = true}, floats = "dark", functions = {}, keywords = {italic = true}, sidebars = "dark", variables = {}}, on_colors = _2_, terminal_colors = true})
  return vim.cmd("colorscheme tokyonight")
end
return {{"folke/tokyonight.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons"}, config = _1_, lazy = false}}
