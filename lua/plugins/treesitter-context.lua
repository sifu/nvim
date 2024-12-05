-- [nfnl] Compiled from fnl/plugins/treesitter-context.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local tc = require("treesitter-context")
  return tc.setup({enable = true, max_lines = 5, min_window_height = 0, line_numbers = true, multiline_threshold = 20, trim_scope = "outer", mode = "cursor", separator = nil, zindex = 20, on_attach = nil, multiwindow = false})
end
return {"nvim-treesitter/nvim-treesitter-context", event = "VeryLazy", config = _1_}
