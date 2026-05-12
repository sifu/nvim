-- [nfnl] fnl/config/markdown.fnl
local wk = require("which-key")
vim.g.markdown_recommended_style = 0
local function toggle_todo_line(line)
  if string.match(line, "- %[.%]") then
    if string.match(line, "- %[ %]") then
      return string.gsub(line, "- %[ %]", "- [x]")
    else
      return string.gsub(line, "- %[.%]", "- [ ]")
    end
  else
    if string.match(line, "^%s*- ") then
      return string.gsub(line, "^(%s*- )", "%1[ ] ")
    else
      return line
    end
  end
end
local function toggle_todo()
  local line = vim.api.nvim_get_current_line()
  local new_line = toggle_todo_line(line)
  if (line ~= new_line) then
    return vim.api.nvim_set_current_line(new_line)
  else
    return nil
  end
end
local function cross_out_todo()
  local line = vim.api.nvim_get_current_line()
  if string.match(line, "- %[.%]") then
    local new_line = string.gsub(line, "- %[.%]", "- [-]")
    return vim.api.nvim_set_current_line(new_line)
  else
    return nil
  end
end
local function _6_()
  vim.opt_local.cursorline = false
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.textwidth = 0
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  return wk.add({{"<c-space>", toggle_todo, {buffer = 0, desc = "Toggle Todo"}}, {"glt", toggle_todo, {buffer = 0, desc = "Toggle Todo"}}, {"glx", cross_out_todo, {buffer = 0, desc = "Cross out Todo"}}})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _6_})
