-- [nfnl] Compiled from fnl/plugins/whichkey.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local groups = {{"<leader>g", "Git"}, {"<leader>c", "Conjure"}, {"<leader>l", "LSP"}, {"<leader>a", "Avante/ChatGPT"}, {"<leader>ac", "ChatGPT"}, {"<leader>t", "Tabs"}, {"<leader>M", "Markdown"}, {"<leader>r", "Refactoring"}, {"<space>", "Search"}, {"ga", "Change Text Case"}}
local function show_help()
  local wk = require("which-key")
  return wk.show()
end
local function enter()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if (ft == "qf") then
    return vim.cmd(".cc")
  else
    return vim.cmd("Telescope buffers")
  end
end
local mappings = {{"n", "yc", "yy<cmd>normal gcc<CR>p", "Copy line and comment out original"}, {"n", "gp", "`[v`]", "Select last changed text"}, {"n", "<c-d>", "<c-d>zz", "Down half a page"}, {"n", "<c-u>", "<c-u>zz", "Up half a page"}, {"n", "<esc>", ":noh<cr><esc>", "Clear Highlightsearch"}, {"i", "<c-bs>", "<c-w>", "Delete word"}, {"i", "<c-h>", "<c-w>", "Delete word"}, {"n", "<leader>?", show_help, "Help"}, {"n", "<leader><leader>", ":wa<cr>", "Write all"}, {"i", "<leader><leader>", "<esc>:wa<cr>", "Write all"}, {"n", "<leader>q", ":qa<cr>", "Quit"}, {"n", "<leader>d", ":bd<cr>", "Delete buffer"}, {"n", "<leader>p", "<cmd>Lazy update<cr>", "Update packages"}, {"n", "<leader>x", ":wa<cr>:!%:p<cr>", "Execute file"}, {"n", "<leader>T", ":!tmux bind t new-window -c $(pwd)<cr>", "Set Tmux to CWD"}, {"n", "<leader>o", ":!open %<cr>", "Open file"}, {"n", "<leader>O", ":!open .<cr>", "Open directory"}, {"n", "-", ":lua require('oil').open_float()<cr>", "Open Parent Directory"}, {"n", "<Tab>", ":bn<cr>", "Next buffer"}, {"n", "<s-Tab>", ":bp<cr>", "Previous buffer"}, {"n", "U", ":redo<cr>", "Redo"}, {"n", "ge", ":e <cfile><cr>", "Open file under cursor"}, {"n", ",,", ":e#<cr>", "Switch between alternate buffers"}, {"n", "<leader>P", "<cmd>ParinferToggle<cr>", "Toggle Parinfer"}, {"n", "<leader>lt", "<cmd>TodoTelescope<cr>", "Todos"}, {"n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"}, {"n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", "Code Definition"}, {"n", "<leader>li", "<cmd>Telescope import<cr>", "Add Import"}, {"n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"}, {"n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", "References"}, {"n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"}, {"n", "<leader>lI", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>gb", "<cmd>Telescope git_branches<cr>", "Checkout branch"}, {"n", "<leader>gc", "<cmd>Telescope git_commits<cr>", "Checkout commit"}, {"n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", "Checkout commit"}, {"n", "<leader>gd", ":DiffviewOpen<CR>", "Diffview"}, {"n", "<leader>gh", ":DiffviewFileHistory %<CR>", "History Current File"}, {"n", "<leader>gH", ":DiffviewFileHistory<CR>", "History All"}, {"n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk"}, {"n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk"}, {"n", "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame"}, {"n", "<leader>go", "<cmd>Telescope git_status<cr>", "Open changed file"}, {"n", "<leader>gv", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk"}, {"n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk"}, {"n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk"}, {"n", "<leader>gU", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk"}, {"n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer"}, {"n", "<leader>MM", "<cmd>RenderMarkdown toggle<cr>", "Toggle Render-Markdown"}, {"n", "<leader>tn", ":tabnew<CR>", "New Tab"}, {"n", "<leader>tc", ":tabclose<CR>", "Close Tab"}, {"n", "<leader>to", ":tabonly<CR>", "Close Other Tabs"}, {"n", "<leader>th", ":tabprevious<CR>", "Previous Tab"}, {"n", "<leader>tl", ":tabnext<CR>", "Next Tab"}, {"n", "\203\153", "<C-W><C-H>", "Window navigation"}, {"n", "\194\172", "<C-W><C-L>", "Window navigation"}, {"n", "\226\136\134", "<C-W><C-J>", "Window navigation"}, {"n", "\203\154", "<C-W><C-K>", "Window navigation"}, {"n", "\195\184", "<C-W><C-O>", "Window only"}, {"n", "\195\159", "<C-W><C-S>", "Window split"}, {"n", "\226\136\154", "<C-W><C-V>", "Window split vertically"}, {"n", "\195\167", "<C-W>c", "Window close"}, {"n", "<enter>", "<cmd>Telescope buffers<cr>", "Buffers"}, {"n", "<space>f", ":lua require('telescope.builtin').find_files()<CR>", "Find Files"}, {"n", "<space>g", ":lua require('telescope.builtin').live_grep()<CR>", "Live Grep"}, {"n", "<space>s", "<cmd>Telescope sessions_picker<cr>", "Sessions"}, {"n", "<space>h", ":lua require('telescope.builtin').help_tags()<CR>", "Help Tags"}, {"n", "<space>r", ":lua require('telescope.builtin').resume()<CR>", "Resume last search"}, {"v", "<", "<gv", "Visualmode indent"}, {"v", ">", ">gv", "Visualmode indent"}}
local function add_mapping(wk, _3_)
  local mode = _3_[1]
  local key = _3_[2]
  local mapping = _3_[3]
  local desc = _3_[4]
  return wk.add({{key, mapping, desc = desc, mode = mode}})
end
local function add_group(wk, _4_)
  local prefix = _4_[1]
  local group = _4_[2]
  return wk.add({{prefix, group = group}})
end
local function add_groups_and_mappings()
  local wk = require("which-key")
  local function _5_(_241)
    return add_group(wk, _241)
  end
  core.map(_5_, groups)
  local function _6_(_241)
    return add_mapping(wk, _241)
  end
  return core.map(_6_, mappings)
end
return {"folke/which-key.nvim", config = add_groups_and_mappings}
