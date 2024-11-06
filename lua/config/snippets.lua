-- [nfnl] Compiled from fnl/config/snippets.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local sn = ls.sn
local all
local function _2_()
  return os.date("%Y-%m-%d")
end
local function _3_()
  return os.date("%H:%M")
end
all = {date = {func(_2_)}, time = {func(_3_)}}
local javascript = {l = fmt("{}", {choice(1, {fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1)}), fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2))", {insert(1)})})}), ll = fmt("{}", {choice(1, {fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1), rep(1)}), fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({},null, 2))", {insert(1), rep(1)})})})}
local function dict__3esnippet_table(dict)
  local result = {}
  for k, v in pairs(dict) do
    table.insert(result, snip({trig = k}, v))
  end
  return result
end
local function setup()
  return ls.add_snippets(nil, {all = dict__3esnippet_table(all), javascript = dict__3esnippet_table(javascript)})
end
return {setup = setup}
