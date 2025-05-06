-- [nfnl] fnl/plugins/substitute.fnl
local function _1_()
  local s = require("substitute")
  return s.operator()
end
local function _2_()
  local s = require("substitute")
  return s.line()
end
local function _3_()
  local s = require("substitute")
  return s.eol()
end
local function _4_()
  local s = require("substitute")
  return s.eol()
end
return {"https://github.com/gbprod/substitute.nvim", keys = {{"<leader>r", _1_}, {"<leader>rr", _2_}, {"<leader>R", _3_}, {"<leader>r", _4_, mode = "v"}}}
