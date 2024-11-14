-- [nfnl] Compiled from fnl/plugins/gx.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.g.netrw_nogx = 1
  return nil
end
local function _2_(mode, line, _)
  local helper = require("gx.helper")
  local pattern = "[\"']([^%s~/]*/[^%s~/]*)[\"']"
  local username_repo = helper.find(line, mode, pattern)
  if username_repo then
    return ("https://github.com/" .. username_repo)
  else
    return nil
  end
end
return {{"chrishrb/gx.nvim", keys = {{"gx", "<cmd>Browse<cr>", mode = {"n", "x"}}}, cmd = {"Browse"}, init = _1_, dependencies = {"nvim-lua/plenary.nvim"}, opts = {handlers = {["nvim-fennel"] = {name = "nvim-fennel", filetype = {"fennel"}, handle = _2_}}}, submodules = false}}
