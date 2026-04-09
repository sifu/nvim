-- [nfnl] fnl/plugins/obsidian.fnl
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
local function _2_(ev)
  vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {buffer = ev.buf, desc = "Follow Link"})
  vim.keymap.set("n", ",O", "<cmd>Obsidian open<cr>", {buffer = ev.buf, desc = "Open in App"})
  vim.keymap.set("n", ",s", "<cmd>Obsidian quick_switch<cr>", {buffer = ev.buf, desc = "Quick Switch"})
  vim.keymap.set("n", ",b", "<cmd>Obsidian backlinks<cr>", {buffer = ev.buf, desc = "Backlinks"})
  vim.keymap.set("n", ",t", "<cmd>Obsidian tags<cr>", {buffer = ev.buf, desc = "Tags"})
  return vim.keymap.set("n", "<CR>", my_smart_action, {buffer = ev.buf})
end
vim.api.nvim_create_autocmd("User", {pattern = "ObsidianNoteEnter", callback = _2_})
local function _3_(uri)
  return vim.ui.open(uri, {cmd = {"open", "-a", "/Applications/Obsidian.app"}})
end
local function _4_(title)
  if (title and (title ~= "")) then
    if title:find("[*\"\\/<>:|?#%^%[%]]") then
      vim.notify(("Invalid filename characters in: " .. title), vim.log.levels.ERROR)
      error("Invalid filename characters")
    else
    end
    return title
  else
    return tostring(vim.fn.strftime("%Y%m%d-%H%M%S"))
  end
end
local function _7_(spec)
  local path = (spec.dir / "Notes" / tostring(spec.id))
  return path:with_suffix(".md")
end
return {"obsidian-nvim/obsidian.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {workspaces = {{name = "Main", path = "~/Obsidian/Main"}}, new_notes_location = "Notes", ui = {enable = false}, footer = {enabled = false}, open = {func = _3_}, completion = {min_chars = 0}, daily_notes = {folder = "Daily"}, note_id_func = _4_, note_path_func = _7_, note = {template = nil}, frontmatter = {enabled = false}, legacy_commands = false}}
