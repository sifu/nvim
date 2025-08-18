-- [nfnl] fnl/config/markdown.fnl
local wk = require("which-key")
vim.g.markdown_recommended_style = 0
local function toggle_todo()
  local line = vim.api.nvim_get_current_line()
  if string.match(line, "- %[.%]") then
    local new_line
    if string.match(line, "- %[ %]") then
      new_line = string.gsub(line, "- %[ %]", "- [x]")
    else
      new_line = string.gsub(line, "- %[.%]", "- [ ]")
    end
    return vim.api.nvim_set_current_line(new_line)
  else
    return nil
  end
end
local function _3_()
  return wk.register({glt = {toggle_todo, "Toggle Todo"}}, {buffer = 0})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _3_})
