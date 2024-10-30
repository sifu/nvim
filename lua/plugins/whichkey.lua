-- [nfnl] Compiled from fnl/plugins/whichkey.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local groups = {{"<leader>g", "Git"}, {"<leader>c", "Conjure"}}
local mappings = {{"n", "<leader><leader>", ":wa<cr>", "Write all"}, {"n", "<leader>q", ":qa<cr>", "Quit"}, {"n", "<leader>d", ":bd<cr>", "Delete buffer"}, {"n", "-", ":lua require('oil').open_float()<cr>", "Open Parent Directory"}, {"v", "<leader>g", "y:!open 'https://www.google.com/search?q=<c-r>\"'<cr>", "Search selection with Google"}}
local function add_mapping(wk, _2_)
  local mode = _2_[1]
  local key = _2_[2]
  local mapping = _2_[3]
  local desc = _2_[4]
  return wk.add({{key, mapping, desc = desc, mode = mode}})
end
local function add_group(wk, _3_)
  local prefix = _3_[1]
  local group = _3_[2]
  return wk.add({{prefix, group = group}})
end
local function add_groups_and_mappings()
  local wk = require("which-key")
  local function _4_(_241)
    return add_group(wk, _241)
  end
  core.map(_4_, groups)
  local function _5_(_241)
    return add_mapping(wk, _241)
  end
  return core.map(_5_, mappings)
end
return {{"folke/which-key.nvim", config = add_groups_and_mappings}}
