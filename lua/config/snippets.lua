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
local state = {counter = 0}
local function here_counter()
  local function _2_()
    state["counter"] = (1 + state.counter)
    return tostring(state.counter)
  end
  return func(_2_)
end
local function upper_case(index)
  local function _5_(_3_)
    local _arg_4_ = _3_[1]
    local arg = _arg_4_[1]
    return arg:gsub("^%l", string.upper)
  end
  return func(_5_, {index})
end
local all
local function _6_()
  return os.date("%Y-%m-%d")
end
local function _7_()
  return os.date("%H:%M")
end
all = {date = {func(_6_)}, time = {func(_7_)}}
local fennel = {core = {text({"(local {: autoload} (require \"nfnl.module\"))", "(local core (autoload \"nfnl.core\"))"})}}
local javascript = {l = fmt("{}", {choice(1, {fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1)}), fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2))", {insert(1)})})}), ll = fmt("{}", {choice(1, {fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1), rep(1)}), fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({},null, 2))", {insert(1), rep(1)})})}), ["{l"] = fmt("{}", {choice(1, {fmt("{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {}) }}", {insert(1)}), fmt("{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}", {insert(1)})})}), ["{ll"] = fmt("{}", {choice(1, {fmt("{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {}) }}", {insert(1), rep(1)}), fmt("{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}", {insert(1), rep(1)})})}), [".thenlog"] = text(".then( result => {console.log(result);return result})"), css = fmt("{}", {choice(1, {fmt("import {} from 'styles/{}.module.css'", {insert(1), rep(1)}), fmt("import {} from './{}.module.css'", {insert(1), rep(1)})})}), descibe = fmt("describe( '{}', () => {{\n  {}\n}})", {insert(1), insert(2)}), expect = fmt("expect({}).toEqual({})", {insert(1), insert(2)}), it = fmt("it( 'should {}', () => {{\n  {}\n}})", {insert(1), insert(2)}), ihtml = fmt("dangerouslySetInnerHTML={{{{__html: {}}}}}", {insert(1)}), json = fmt("JSON.stringify({}, null, 2)", {insert(1)}), prejson = fmt("<pre style={{{{ color: '#333', backgroundColor: '#efefef', padding: '10px', margin: '10px', border: '1px solid #ccc' }}}}>{{ JSON.stringify({}, null, 2)}}</pre>", {insert(1)}), useEffect = fmt("useEffect(( ) => {{\n  {}\n}}, [{}])", {insert(2), insert(1)}), ue = fmt("useEffect(( ) => {{\n  {}\n}}, [{}])", {insert(2), insert(1)}), h = fmt("console.log('--- {} ---')", {here_counter()}), us = fmt("const [{}, set{}] = useState({})", {insert(1), upper_case(1), insert(0)}), useState = fmt("const [{}, set{}] = useState({})", {insert(1), upper_case(1), insert(0)})}
local filetype_snippets = {all = all, fennel = fennel, javascript = javascript}
local function dict__3esnippet_table(dict)
  local result = {}
  for k, v in pairs(dict) do
    table.insert(result, snip({trig = k}, v))
  end
  return result
end
local function map_value(f, dict)
  local result = {}
  for k, v in pairs(dict) do
    core.assoc(result, k, f(v))
  end
  return result
end
local function setup()
  return ls.add_snippets(nil, map_value(dict__3esnippet_table, filetype_snippets))
end
return {setup = setup}
