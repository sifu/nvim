-- [nfnl] Compiled from fnl/plugins/refactoring.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local refactoring = require("refactoring")
  local telescope = require("telescope")
  refactoring.setup({})
  return telescope.load_extension("refactoring")
end
local function _2_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Extract Function")
end
local function _3_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Extract Function To File")
end
local function _4_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Extract Variable")
end
local function _5_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Inline Function")
end
local function _6_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Inline Variable")
end
local function _7_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Extract Block")
end
local function _8_()
  local refactoring = require("refactoring")
  return refactoring.refactor("Extract Block To File")
end
return {"ThePrimeagen/refactoring.nvim", dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, config = _1_, keys = {{"<leader>re", _2_, mode = {"x"}, desc = "Extract Function"}, {"<leader>rf", _3_, mode = {"x"}, desc = "Extract Function To File"}, {"<leader>rv", _4_, mode = {"x"}, desc = "Extract Variable"}, {"<leader>rI", _5_, mode = {"n"}, desc = "Inline Function"}, {"<leader>ri", _6_, mode = {"n", "x"}, desc = "Inline Variable"}, {"<leader>rbb", _7_, mode = {"n"}, desc = "Extract Block"}, {"<leader>rbf", _8_, mode = {"n"}, desc = "Extract Block To File"}}}
