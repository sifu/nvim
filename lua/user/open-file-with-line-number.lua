-- [nfnl] fnl/user/open-file-with-line-number.fnl
local function _1_(opts)
  local arg = opts.args
  local parts = vim.split(arg, ":", true)
  local file = parts[1]
  local line = ((parts[2] and tonumber(parts[2])) or 1)
  local col = ((parts[3] and tonumber(parts[3])) or 1)
  vim.cmd(("edit " .. file))
  return vim.api.nvim_win_set_cursor(0, {line, col})
end
return vim.api.nvim_create_user_command("E", _1_, {nargs = 1, complete = "file", desc = "Open file with line:column navigation (e.g., :E file.txt:10:5)"})
