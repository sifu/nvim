-- [nfnl] Compiled from fnl/plugins/luasnip.fnl by https://github.com/Olical/nfnl, do not edit.
local snippets = require("config.snippets")
local function setup()
  local ls = require("luasnip")
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
  return snippets.setup()
end
return {{"L3MON4D3/LuaSnip", config = setup}}
