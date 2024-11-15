-- [nfnl] Compiled from fnl/plugins/luasnip.fnl by https://github.com/Olical/nfnl, do not edit.
local function setup()
  local ls = require("luasnip")
  local snippets = require("config.snippets")
  ls.config.set_config({updateevents = "TextChanged,TextChangedI", enable_autosnippets = false, history = false})
  snippets.setup()
  local function _1_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-space>", _1_, {desc = "LuaSnip expand/jump", silent = true})
  local function _3_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _3_, {desc = "LuaSnip expand/jump", silent = true})
  local function _5_()
    if ls.jumpable(-1) then
      return ls.jump(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-j>", _5_, {desc = "LuaSnip expand/jump", silent = true})
  local function _7_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  return vim.keymap.set({"i", "s"}, "<c-l>", _7_, {desc = "LuaSnip choices", silent = true})
end
return {"L3MON4D3/LuaSnip", config = setup}
