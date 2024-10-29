-- [nfnl] Compiled from fnl/config/init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
vim.keymap.set("n", "\226\130\172", "<nop>", {noremap = true})
require("config.keymaps")
do
  local options = {expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2, completeopt = "menuone,noselect", ignorecase = true, smartcase = true, number = true, relativenumber = true, ruler = true, signcolumn = "number", background = "light"}
  for option, value in pairs(options) do
    core.assoc(vim.o, option, value)
  end
end
return {}
