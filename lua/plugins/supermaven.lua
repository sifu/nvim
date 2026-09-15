-- [nfnl] fnl/plugins/supermaven.fnl
local function toggle()
  local api = require("supermaven-nvim.api")
  api.toggle()
  local _1_
  if api.is_running() then
    _1_ = "enabled"
  else
    _1_ = "disabled"
  end
  return vim.notify(("Supermaven " .. _1_))
end
local function _3_()
  return (vim.bo.buftype == "prompt")
end
return {"supermaven-inc/supermaven-nvim", event = "VeryLazy", keys = {{"<leader>aa", toggle, desc = "Toggle AI Completion"}}, opts = {ignore_filetypes = {markdown = true, TelescopePrompt = true}, condition = _3_, color = {suggestion_color = "#DC8CE2", cterm = 117}}}
