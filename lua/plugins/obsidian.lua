-- [nfnl] fnl/plugins/obsidian.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function today()
  local today0 = os.date("%Y-%m-%d")
  return ("[[/Daily/" .. today0 .. "|" .. today0 .. "]]")
end
local function my_smart_action()
  local obsidian = require("obsidian")
  local cursor_link = obsidian.api.cursor_link
  local cursor_tag = obsidian.api.cursor_tag
  if cursor_link() then
    return vim.cmd("Obsidian follow_link")
  elseif cursor_tag() then
    return vim.cmd("Obsidian tags")
  else
    return vim.cmd("Telescope buffers")
  end
end
local function _3_(ev)
  vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {buffer = ev.buf, desc = "Follow Link"})
  vim.keymap.set("n", ",O", "<cmd>Obsidian open<cr>", {buffer = ev.buf, desc = "Open in App"})
  vim.keymap.set("n", ",s", "<cmd>Obsidian quick_switch<cr>", {buffer = ev.buf, desc = "Quick Switch"})
  vim.keymap.set("n", ",b", "<cmd>Obsidian backlinks<cr>", {buffer = ev.buf, desc = "Backlinks"})
  vim.keymap.set("n", ",t", "<cmd>Obsidian tags<cr>", {buffer = ev.buf, desc = "Tags"})
  return vim.keymap.set("n", "<CR>", my_smart_action, {buffer = ev.buf})
end
vim.api.nvim_create_autocmd("User", {pattern = "ObsidianNoteEnter", callback = _3_})
local function _4_(uri)
  return vim.ui.open(uri, {cmd = {"open", "-a", "/Applications/Obsidian.app"}})
end
local function _5_(spec)
  local path = (spec.dir / tostring(spec.title))
  return path:with_suffix(".md")
end
local function _6_(note)
  return core.merge({["date-created"] = today()}, note.metadata)
end
return {"obsidian-nvim/obsidian.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {workspaces = {{name = "Main", path = "~/Obsidian/Main"}}, new_notes_location = "Notes", ui = {enable = false}, open = {func = _4_}, completion = {min_chars = 0}, daily_notes = {folder = "Daily"}, note_path_func = _5_, ["frontmatter.func"] = _6_, legacy_commands = false}}
