-- [nfnl] fnl/plugins/luasnip.fnl
local function setup()
  local ls = require("luasnip")
  local supermaven = require("supermaven-nvim.completion_preview")
  local snippets = require("config.snippets")
  ls.config.set_config({updateevents = "TextChanged,TextChangedI", enable_autosnippets = false, history = false})
  snippets.setup()
  local function _1_()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
    end
    if supermaven.has_suggestion() then
      return supermaven.on_accept_suggestion_word()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _1_, {desc = "LuaSnip expand/jump", silent = true})
  local function _4_()
    if ls.jumpable(-1) then
      return ls.jump(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-j>", _4_, {desc = "LuaSnip expand/jump", silent = true})
  local function _6_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  return vim.keymap.set({"i", "s"}, "<c-l>", _6_, {desc = "LuaSnip choices", silent = true})
end
return {"L3MON4D3/LuaSnip", config = setup, dependencies = {"supermaven-inc/supermaven-nvim"}, event = "VeryLazy"}
