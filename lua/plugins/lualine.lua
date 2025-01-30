-- [nfnl] Compiled from fnl/plugins/lualine.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local lsp = autoload("config.lsp")
local function lsp_connection()
  local message = lsp["get-progress-message"]()
  if ((message.status == "begin") or (message.status == "report")) then
    return (message.msg .. " : " .. message.percent .. "%% \239\130\150")
  elseif (message.status == "end") then
    return "\239\131\136"
  elseif ((message.status == "") and not vim.tbl_isempty(vim.lsp.buf_get_clients(0))) then
    return "\239\131\136"
  else
    return "\239\130\150"
  end
end
local function macro_recording()
  if core["empty?"](vim.fn.reg_recording()) then
    return ""
  else
    return ("\240\159\148\180@" .. vim.fn.reg_recording())
  end
end
local function _4_()
  local lualine = require("lualine")
  return lualine.refresh({place = {"statusline"}})
end
vim.api.nvim_create_autocmd("RecordingEnter", {callback = _4_})
local function _5_()
  local lualine = require("lualine")
  local timer = vim.loop.new_timer()
  local function _6_()
    return lualine.refresh({place = {"statusline"}})
  end
  return timer:start(50, 0, vim.schedule_wrap(_6_))
end
vim.api.nvim_create_autocmd("RecordingLeave", {callback = _5_})
local function _7_()
  local lualine = require("lualine")
  local lualine_theme = require("lualine.themes.material")
  return lualine.setup({options = {theme = lualine_theme, icons_enabled = true, component_separators = {left = "\238\130\177", right = "\238\130\179"}, section_separators = {left = "\238\130\176", right = "\238\130\178"}}, sections = {lualine_a = {"mode", {upper = true}}, lualine_b = {"branch", {"diff", diff_color = {modified = {fg = "#87afff"}}}}, lualine_c = {{"filename", file_status = true, path = 1, shorting_target = 40}, {macro_recording}}, lualine_x = {{lsp_connection}, "location", "progress", "filetype"}, lualine_y = {"encoding"}, lualine_z = {}}, inactive_sections = {lualine_a = {}, lualine_b = {}, lualine_c = {{"filename", file_status = true, path = 1}}, lualine_x = {}, lualine_y = {}, lualine_z = {}}})
end
return {"nvim-lualine/lualine.nvim", config = _7_}
