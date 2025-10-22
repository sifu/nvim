-- [nfnl] fnl/config/snippets.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local _local_2_ = autoload("nfnl.string")
local split = _local_2_.split
local join = _local_2_.join
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
  local function _3_()
    state["counter"] = (1 + state.counter)
    return tostring(state.counter)
  end
  return func(_3_)
end
local function upper_case_first_letter(str)
  return str:gsub("^%l", string.upper)
end
local function upper_case(index)
  local function _6_(_4_)
    local _arg_5_ = _4_[1]
    local arg = _arg_5_[1]
    return upper_case_first_letter(arg)
  end
  return func(_6_, {index})
end
local function tag(name)
  return {text(("<" .. name .. ">")), choice(1, {sn(nil, {insert(1)}), sn(nil, {text({"", "  "}), insert(1), text({"", ""})})}), text(("</" .. name .. ">")), insert(0)}
end
local function filename_without_extension()
  return vim.fn.expand("%:t:r")
end
local function kebab_to_pascal_case(str)
  return join(core.map(upper_case_first_letter, split(str, "-")))
end
local function daily_link(date)
  return ("[[/Daily/" .. date .. "|" .. date .. "]]")
end
local all
local function _7_()
  return os.date("%Y-%m-%d")
end
local function _8_()
  return os.date("%H:%M")
end
all = {date = {func(_7_)}, time = {func(_8_)}}
local fennel = {core = {text({"(local {: autoload} (require \"nfnl.module\"))", "(local core (autoload \"nfnl.core\"))"})}, fn = {text("\206\187 ")}}
local typescript
local function _9_()
  return kebab_to_pascal_case(filename_without_extension())
end
local function _10_()
  return ("<div data-component='" .. kebab_to_pascal_case(filename_without_extension()) .. "'>" .. kebab_to_pascal_case(filename_without_extension()) .. "</div>")
end
typescript = {l = fmt("{}", {choice(1, {fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1)}), fmt("console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2))", {insert(1)})})}), ll = fmt("{}", {choice(1, {fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {})", {insert(1), rep(1)}), fmt("console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({},null, 2))", {insert(1), rep(1)})})}), copy = fmt("// prettier-ignore\nnavigator.clipboard.writeText(JSON.stringify({}, null, 2)).then(() => console.log('Text copied to clipboard', JSON.stringify({}, null, 2)))", {insert(1), rep(1)}), ["{l"] = fmt("{}", {choice(1, {fmt("{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {}) }}", {insert(1)}), fmt("{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}", {insert(1)})})}), ["{ll"] = fmt("{}", {choice(1, {fmt("{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {}) }}", {insert(1), rep(1)}), fmt("{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}", {insert(1), rep(1)})})}), [".thenlog"] = text(".then( result => {console.log(result);return result})"), css = fmt("{}", {choice(1, {fmt("import {} from 'styles/{}.module.css'", {insert(1), rep(1)}), fmt("import {} from './{}.module.css'", {insert(1), rep(1)})})}), descibe = fmt("describe( '{}', () => {{\n  {}\n}})", {insert(1), insert(2)}), expect = fmt("expect({}).toEqual({})", {insert(1), insert(2)}), it = fmt("it( 'should {}', () => {{\n  {}\n}})", {insert(1), insert(2)}), ihtml = fmt("dangerouslySetInnerHTML={{{{__html: {}}}}}", {insert(1)}), json = fmt("JSON.stringify({}, null, 2)", {insert(1)}), prejson = fmt("<pre onClick={{() => {{ navigator.clipboard.writeText(JSON.stringify({}, null, 2)).then(() => alert('Copied to clipboard!')).catch(err => console.error('Failed to copy:', err)) }}}} style={{{{ color: '#333', backgroundColor: '#efefef', padding: '10px', margin: '10px', border: '1px solid #ccc', cursor: 'pointer' }}}}> {{ JSON.stringify({}, null, 2) }}</pre>", {insert(1), rep(1)}), useEffect = fmt("useEffect(( ) => {{\n  {}\n}}, [{}])", {insert(2), insert(1)}), ue = fmt("useEffect(( ) => {{\n  {}\n}}, [{}])", {insert(2), insert(1)}), h = fmt("console.log('--- {} ---')", {here_counter()}), us = fmt("const [{}, set{}] = useState({})", {insert(1), upper_case(1), insert(0)}), useState = fmt("const [{}, set{}] = useState({})", {insert(1), upper_case(1), insert(0)}), p = tag("p"), div = tag("div"), html = tag("html"), head = tag("head"), title = tag("title"), body = tag("body"), article = tag("article"), section = tag("section"), aside = tag("aside"), button = tag("button"), h1 = tag("h1"), h2 = tag("h2"), h3 = tag("h3"), h4 = tag("h4"), h5 = tag("h5"), h6 = tag("h6"), hgroup = tag("hgroup"), header = tag("header"), pre = tag("pre"), blockquote = tag("blockquote"), ol = tag("ol"), ul = tag("ul"), li = tag("li"), i = tag("i"), strong = tag("strong"), b = tag("b"), table = tag("table"), thead = tag("thead"), tbody = tag("tbody"), tr = tag("tr"), th = tag("th"), td = tag("td"), span = tag("span"), label = tag("label"), form = tag("form"), imp = fmt("import {} from '{}'", {choice(1, {insert(1), fmt("{{ {} }}", {insert(1)})}), insert(2)}), c = fmt("className={}{}", {choice(1, {fmt("'{}'", {insert(1)}), fmt("{{{}}}", {insert(1)})}), insert(0)}), fun = {text("const "), insert(1, "name"), text(" = "), choice(2, {sn(nil, insert(1)), text("( )"), fmt("( {} )", insert(1)), fmt("( {{ {} }})", insert(1))}), text(" => "), choice(3, {sn(nil, {insert(1)}), fmt("(\n  {}\n)", insert(1)), fmt("{{\n  return (\n    {}\n  )\n}}", insert(1))}), insert(0)}, comp = {text("export default function "), func(_9_), text("("), choice(1, {text(" "), fmt("{{ {} }}", insert(1))}), text({") {", "  return (", "    "}), choice(2, {func(_10_), text("")}), text({"", "  )", "}"})}, ["todo:"] = text("TODO: ")}
local markdown
local function _11_()
  return daily_link(os.date("%Y-%m-%d"))
end
local function _12_()
  return daily_link(os.date("%Y-%m-%d", (os.time() - 86400)))
end
markdown = {td = {text("- [ ] ")}, info = {text("> [!INFO] ")}, warning = {text("> [!WARNING] ")}, warn = {text("> [!WARNING] ")}, question = {text("> [!QUESTION] ")}, today = {func(_11_)}, yesterday = {func(_12_)}}
local filetype_snippets = {all = all, fennel = fennel, markdown = markdown, typescript = typescript, typescriptreact = vim.deepcopy(typescript)}
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
