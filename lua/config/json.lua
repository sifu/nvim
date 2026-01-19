-- [nfnl] fnl/config/json.fnl
local function _1_()
  vim.opt_local.conceallevel = 0
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "json", callback = _1_})
return {}
