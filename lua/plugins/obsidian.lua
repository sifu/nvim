-- [nfnl] fnl/plugins/obsidian.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function today()
  local today0 = os.date("%Y-%m-%d")
  return ("[[/Daily/" .. today0 .. "|" .. today0 .. "]]")
end
local function delete_cr_mapping()
  return pcall(vim.keymap.del, "n", "<CR>", {buffer = 0})
end
local function _2_(ev)
  vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {buffer = ev.buf, desc = "Follow Link"})
  vim.keymap.set("n", ",s", "<cmd>Obsidian quick_switch<cr>", {buffer = ev.buf, desc = "Quick Switch"})
  vim.keymap.set("n", ",b", "<cmd>Obsidian backlinks<cr>", {buffer = ev.buf, desc = "Backlinks"})
  vim.keymap.set("n", ",t", "<cmd>Obsidian tags<cr>", {buffer = ev.buf, desc = "Tags"})
  return delete_cr_mapping()
end
vim.api.nvim_create_autocmd("User", {pattern = "ObsidianNoteEnter", callback = _2_})
local function _3_(uri)
  return vim.ui.open(uri, {cmd = {"open", "-a", "/Applications/Obsidian.app"}})
end
local function _4_(spec)
  local path = (spec.dir / tostring(spec.title))
  return path:with_suffix(".md")
end
local function _5_(note)
  return core.merge({["date-created"] = today()}, note.metadata)
end
return {"obsidian-nvim/obsidian.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {workspaces = {{name = "Main", path = "~/Obsidian/Main"}}, new_notes_location = "Notes", ui = {enable = false}, open = {func = _3_}, completion = {min_chars = 0}, daily_notes = {folder = "Daily"}, note_path_func = _4_, note_frontmatter_func = _5_, legacy_commands = false}}
