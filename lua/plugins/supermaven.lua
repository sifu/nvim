-- [nfnl] fnl/plugins/supermaven.fnl
local function _1_()
  return (vim.bo.buftype == "prompt")
end
return {"supermaven-inc/supermaven-nvim", event = "VeryLazy", opts = {ignore_filetypes = {markdown = true, TelescopePrompt = true}, condition = _1_, color = {suggestion_color = "#DC8CE2", cterm = 117}}}
