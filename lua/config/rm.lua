-- [nfnl] Compiled from fnl/config/rm.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.cmd.Remove()
  return vim.cmd.bd()
end
return vim.api.nvim_create_user_command("Rm", _1_, {})
