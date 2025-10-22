-- [nfnl] fnl/plugins/flash.fnl
local function _1_()
  local flash = require("flash")
  return flash.jump()
end
local function _2_()
  local flash = require("flash")
  return flash.treesitter()
end
return {"folke/flash.nvim", event = "VeryLazy", keys = {{"s", _1_, mode = {"n", "x", "o"}, desc = "Flash"}, {"S", _2_, mode = {"n", "x", "o"}, desc = "Flash Treesitter"}}}
