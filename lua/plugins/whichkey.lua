-- [nfnl] Compiled from fnl/plugins/whichkey.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local groups = {{"<leader>g", "Git"}, {"<leader>c", "Conjure"}, {"<leader>a", "AI/ChatGPT"}, {"<space>", "Find"}, {"ga", "Change Text Case"}}
local function show_help()
  local wk = require("which-key")
  return wk.show()
end
local mappings = {{"n", "<leader>?", show_help, "Help"}, {"n", "<leader><leader>", ":wa<cr>", "Write all"}, {"i", "<leader><leader>", "<esc>:wa<cr>", "Write all"}, {"n", "<leader>q", ":qa<cr>", "Quit"}, {"n", "<leader>d", ":bd<cr>", "Delete buffer"}, {"n", "gp", "`[v`]", "Select last changed text"}, {"n", "-", ":lua require('oil').open_float()<cr>", "Open Parent Directory"}, {"n", "<Tab>", ":bn<cr>", "Next buffer"}, {"n", "<s-Tab>", ":bp<cr>", "Previous buffer"}, {"n", "U", ":redo<cr>", "Redo"}, {"n", "gf", ":e <cfile><cr>", "Open file under cursor"}, {"n", ",,", ":e#<cr>", "Switch between alternate buffers"}, {"n", "\203\153", "<C-W><C-H>", "Window navigation"}, {"n", "\194\172", "<C-W><C-L>", "Window navigation"}, {"n", "\226\136\134", "<C-W><C-J>", "Window navigation"}, {"n", "\203\154", "<C-W><C-K>", "Window navigation"}, {"n", "\195\184", "<C-W><C-O>", "Window only"}, {"n", "\195\159", "<C-W><C-S>", "Window split"}, {"n", "\226\136\154", "<C-W><C-V>", "Window split vertically"}, {"n", "\195\167", "<C-W>c", "Window close"}, {"n", "<enter>", ":lua require('telescope.builtin').buffers()<CR>", "Buffers"}, {"n", "<space>f", ":lua require('telescope.builtin').find_files()<CR>", "Find Files"}, {"n", "<space>g", ":lua require('telescope.builtin').live_grep()<CR>", "Live Grep"}, {"n", "<space>h", ":lua require('telescope.builtin').help_tags()<CR>", "Help Tags"}, {"v", "<leader>g", "y:!open 'https://www.google.com/search?q=<c-r>\"'<cr>", "Search selection with Google"}}
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
