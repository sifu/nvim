-- [nfnl] Compiled from fnl/config/session-load.fnl by https://github.com/Olical/nfnl, do not edit.
vim.api.nvim_create_augroup("SessionLoad", {clear = true})
local function _1_()
  local rename_cmd = ("silent !tmux rename-window \"\238\152\171 " .. vim.fs.basename(vim.v.this_session) .. "\"")
  vim.cmd("silent !tmux bind t new-window -c $(pwd)")
  return vim.cmd(rename_cmd)
end
return vim.api.nvim_create_autocmd({"SessionLoadPost"}, {pattern = "*", group = "SessionLoad", callback = _1_})
