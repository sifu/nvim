-- [nfnl] fnl/plugins/obsidian.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function today()
  local today0 = os.date("%Y-%m-%d")
  return ("[[/Daily/" .. today0 .. "|" .. today0 .. "]]")
end
local function _2_(spec)
  local path = (spec.dir / tostring(spec.title))
  return path:with_suffix(".md")
end
local function _3_(note)
  return core.merge({["date-created"] = today()}, note.metadata)
end
return {"epwalsh/obsidian.nvim", version = "*", lazy = true, ft = "markdown", dependencies = {"nvim-lua/plenary.nvim"}, opts = {workspaces = {{name = "Main", path = "~/Obsidian/Main"}}, ui = {enable = false}, use_advanced_uri = true, open_app_foreground = true, completion = {min_chars = 1}, note_path_func = _2_, note_frontmatter_func = _3_}}
