-- [nfnl] fnl/config/gitcommit.fnl
local function _1_()
  vim.opt_local.textwidth = 72
  return nil
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "gitcommit", callback = _1_})
