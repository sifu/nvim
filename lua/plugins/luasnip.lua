-- [nfnl] Compiled from fnl/plugins/luasnip.fnl by https://github.com/Olical/nfnl, do not edit.
local function setup()
  local ls = require("luasnip")
  local _fmt = require("luasnip.extras.fmt")
  local extras = require("luasnip.extras")
  local fmt = _fmt.fmt
  local rep = extras.rep
  local snip = ls.snippet
  local text = ls.text_node
  local insert = ls.insert_node
  local func = ls.function_node
  local choice = ls.choice_node
  local sn = ls.sn
  local function _1_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _1_, {desc = "LuaSnip expand/jump", silent = true})
  local function _3_()
    if ls.jumpable(-1) then
      return ls.jump(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-j>", _3_, {desc = "LuaSnip expand/jump", silent = true})
  local function _5_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-l>", _5_, {desc = "LuaSnip expand/jump", silent = true})
  local function _7_()
    return ("Hello" .. "World")
  end
  ls.add_snippets(nil, {all = {snip({trig = "date", namr = "Date", dscr = "Date"}, {func(_7_, {})})}})
  return print("TODO: port from old config")
end
return {{"L3MON4D3/LuaSnip", config = setup}}
