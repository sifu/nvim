-- [nfnl] Compiled from fnl/plugins/sonarlint.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local sonarlint = require("sonarlint")
  return sonarlint.setup({server = {cmd = {"sonarlint-language-server", "-stdio", "-analyzers", vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar")}, settings = {sonarlint = {rules = {["typescript:S6660"] = {level = "off"}, ["typescript:S6819"] = {level = "off"}}}}}, filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"}})
end
return {"https://gitlab.com/schrieveslaach/sonarlint.nvim", config = _1_}
