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
local function test_toggle_todo()
  local tests = {{"- blabla muh kuh", "- [ ] blabla muh kuh"}, {"  - item", "  - [ ] item"}, {"- [ ] task", "- [x] task"}, {"- [x] done task", "- [ ] done task"}, {"- [-] crossed", "- [ ] crossed"}, {"regular text", "regular text"}}
  for i, _6_ in ipairs(tests) do
    local input = _6_[1]
    local expected = _6_[2]
    local result = toggle_todo_line(input)
    if (result == expected) then
      print(string.format("\226\156\147 Test %d passed: '%s' -> '%s'", i, input, result))
    else
      print(string.format("\226\156\151 Test %d failed: '%s' -> '%s' (expected '%s')", i, input, result, expected))
    end
  end
  return nil
end
local function _8_()
  vim.opt_local.cursorline = false
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.textwidth = 0
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  return wk.add({{"<c-space>", toggle_todo, {buffer = 0, desc = "Toggle Todo"}}, {"glt", toggle_todo, {buffer = 0, desc = "Toggle Todo"}}, {"glx", cross_out_todo, {buffer = 0, desc = "Cross out Todo"}}})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _8_})
