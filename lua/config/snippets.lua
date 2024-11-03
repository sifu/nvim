-- [nfnl] Compiled from fnl/config/snippets.fnl by https://github.com/Olical/nfnl, do not edit.
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local sn = ls.sn
local function setup()
  return print("TODO: port from old config")
end
return {setup = setup}
