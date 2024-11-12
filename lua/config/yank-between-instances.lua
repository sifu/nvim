-- [nfnl] Compiled from fnl/config/yank-between-instances.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  return vim.cmd("rshada")
end
vim.api.nvim_create_autocmd({"CursorHold", "FocusGained"}, {pattern = "*", callback = _1_})
return vim.api.nvim_create_autocmd({"TextYankPost"}, {pattern = {"*"}, command = "wshada"})
