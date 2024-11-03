-- [nfnl] Compiled from fnl/plugins/various-text-objects.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local textobjs = require("various-textobjs")
  return textobjs.setup({useDefaultKeymaps = true, disabledKeymaps = {"gc"}})
end
return {"chrisgrieser/nvim-various-textobjs", event = "UIEnter", config = _1_}
