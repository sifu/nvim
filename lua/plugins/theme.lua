-- [nfnl] Compiled from fnl/plugins/theme.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local theme = require("onenord")
  local color_module = require("onenord.colors")
  local colors = color_module.load()
  theme.setup({theme = "light", borders = true, styles = {comments = "NONE", strings = "NONE", keywords = "NONE", functions = "NONE", variables = "NONE", diagnostics = "underline"}, disable = {eob_lines = true, background = false, cursorline = false}, custom_highlights = {VimwikiLink = {fg = colors.dark_blue, gui = nil}, VimwikiListTodo = {fg = colors.purple}, VimwikiHeaderChar = {guibg = nil}, VimwikiError = {guibg = nil}, CursorLineNr = {bg = "#efefef"}, LineNr = {guifg = "#550055"}, Underlined = {guifg = "#15729e"}, Search = {guibg = "#f1f1f1", guifg = nil}, TreesitterContextLineNumber = {bg = "#eeeeee"}, TelescopePromptBorder = {fg = "#e0e0e0"}, TelescopeResultsBorder = {fg = "#e0e0e0"}, TelescopePreviewBorder = {fg = "#e0e0e0"}, NormalFloat = {fg = "#2E3440", bg = "#DFDFDF"}, FloatBorder = {fg = "#6087d7", bg = "#FFFFFF"}, FloatTitle = {fg = "#6087d7"}, RenderMarkdownH1Bg = {bg = "#efefef"}, RenderMarkdownH2Bg = {bg = "#efefef"}, RenderMarkdownH3Bg = {bg = "#efefef"}, RenderMarkdownH4Bg = {bg = "#efefef"}, RenderMarkdownH5Bg = {bg = "#efefef"}, RenderMarkdownH6Bg = {bg = "#efefef"}, derMarkdownCanceled = {fg = "#59636e"}, Visual = {bg = "#fff6d5"}, CodeiumSuggestion = {fg = "#333333", bg = "#efefef"}}, custom_colors = {bg = "#ffffff"}, fade_nc = false})
  return vim.cmd("colorscheme onenord")
end
return {"https://github.com/rmehri01/onenord.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons"}, config = _1_, lazy = false}
