-- [nfnl] fnl/plugins/whichkey.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local function _2_()
  if (vim.v.count == 0) then
    return "gk"
  else
    return "k"
  end
end
vim.keymap.set("n", "k", _2_, {expr = true})
local function _4_()
  if (vim.v.count == 0) then
    return "gj"
  else
    return "j"
  end
end
vim.keymap.set("n", "j", _4_, {expr = true})
vim.keymap.set("c", "<c-a>", "<home>", {noremap = true})
vim.keymap.set("c", "<c-b>", "<left>", {noremap = true})
vim.keymap.set("c", "<c-d>", "<del>", {noremap = true})
vim.keymap.set("c", "<c-e>", "<end>", {noremap = true})
vim.keymap.set("c", "<c-f>", "<right>", {noremap = true})
vim.keymap.set("c", "<c-n>", "<down>", {noremap = true})
vim.keymap.set("c", "<c-p>", "<up>", {noremap = true})
local groups = {{"<leader>g", "Git"}, {"<leader>l", "LSP"}, {"<leader>a", "ChatGPT"}, {"<leader>c", "Conjure"}, {"<leader>s", "SQL"}, {"<leader>t", "Tabs"}, {"<leader>M", "Markdown"}, {"<leader>C", "Copy Filepath"}, {"<space>", "Search"}, {"ga", "Change Text Case"}}
local function _6_()
  return vim.keymap.set("n", "<enter>", "<Nop>", {buffer = true})
end
vim.api.nvim_create_autocmd("CmdwinEnter", {callback = _6_})
local function show_help()
  local wk = require("which-key")
  return wk.show()
end
local function add_to_obsidian_inbox()
  local filename = vim.fn.input("Title: (without .md) ", "", "file")
  if (filename ~= "") then
    return vim.cmd((":split /s/Obsidian/Main/Inbox/" .. filename .. ".md"))
  else
    return nil
  end
end
local function copy_and_notify(text)
  vim.fn.setreg("+", text)
  vim.notify(("Copied: " .. text))
  return text
end
local function copy_filepath_with_line()
  local filepath = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local filepath_with_line = ("@" .. filepath .. " on line " .. line_number)
  return copy_and_notify(filepath_with_line)
end
local function copy_file_reference()
  local filepath = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local filepath_with_line = (filepath .. ":" .. line_number)
  return copy_and_notify(filepath_with_line)
end
local function copy_filepath()
  local filepath = vim.fn.expand("%")
  local prefixed = ("@" .. filepath)
  return copy_and_notify(prefixed)
end
local function copy_word_with_filepath()
  local word = vim.fn.expand("<cword>")
  local filepath = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local word_with_filepath = ("`" .. word .. "` (@" .. filepath .. " on line " .. line_number .. ")")
  return copy_and_notify(word_with_filepath)
end
local function copy_filepath_with_line_range()
  local filepath = vim.fn.expand("%")
  local start_line = vim.fn.getpos("v")[2]
  local end_line = vim.fn.line(".")
  local sorted_start = math.min(start_line, end_line)
  local sorted_end = math.max(start_line, end_line)
  local filepath_with_range = ("@" .. filepath .. " line " .. sorted_start .. " to " .. sorted_end)
  return copy_and_notify(filepath_with_range)
end
local mappings = {{"n", ",S", "<cmd>e /s/tmp/scratchpad.fnl<cr>", "Open Scratchpad"}, {"n", ",i", add_to_obsidian_inbox, "Add to Obsidian Inbox"}, {"n", ",o", "<cmd>Obsidian<cr>", "Open Obsidian"}, {"n", ",s", "<cmd>Obsidian quick_switch<cr>", "Obsidian Quick Switch"}, {"n", ",n", "<cmd>Obsidian new<cr>", "New Obsidian Note"}, {"n", "<leader>u", "<cmd>Atone toggle<cr>", "Undo Tree"}, {"n", "<leader>U", "gUiw", "Uppercase word"}, {"n", "<leader>Cr", copy_file_reference, "Copy current file reference"}, {"n", "<leader>Cc", copy_filepath_with_line, "Copy current filepath with line number"}, {"n", "<leader>CC", copy_filepath, "Copy current filepath"}, {"n", "<leader>Cw", copy_word_with_filepath, "Copy word under cursor with filepath and line number"}, {"v", "<leader>Cr", copy_filepath_with_line_range, "Copy filepath with line range"}, {"n", "gp", "`[v`]", "Select last changed text"}, {"n", "<c-d>", "<c-d>zz", "Down half a page"}, {"n", "<c-u>", "<c-u>zz", "Up half a page"}, {"n", "<esc>", ":noh<cr><esc>", "Clear Highlightsearch"}, {"i", "<c-bs>", "<c-w>", "Delete word"}, {"i", "<c-h>", "<c-w>", "Delete word"}, {"i", "<c-a>", "<esc>?<<cr>:noh<cr>ea<space>", "Add property to tag"}, {"i", "<c-t>", "<esc>/++<cr>cf+", "Replace next marker"}, {"n", "<c-t>", "/++<cr>cf+", "Replace next marker"}, {"n", "<c-p>", "/><cr>:noh<cr>a", "Insert inside tag"}, {"n", "<leader>?", show_help, "Help"}, {"n", "<leader><leader>", ":wa<cr>", "Write all"}, {"i", "<leader><leader>", "<esc>:wa<cr>", "Write all"}, {"n", "<leader>q", ":qa<cr>", "Quit"}, {"n", "<leader>d", ":bd<cr>", "Delete buffer"}, {"n", "<leader>p", ":!git pull<cr><cmd>MasonUpdate<cr><cmd>Lazy update<cr>", "Update packages"}, {"n", "<leader>x", ":wa<cr>:!%:p<cr>", "Execute file"}, {"n", "<leader>T", ":!tmux bind t new-window -c $(pwd)<cr><cr>", "Set Tmux to CWD"}, {"n", "<leader>o", ":!open %<cr>", "Open file"}, {"n", "<leader>O", ":!open %:p:h<cr>", "Open directory"}, {"n", "-", ":lua require('oil').open_float()<cr>", "Open Parent Directory"}, {"n", "<Tab>", ":bn<cr>", "Next buffer"}, {"n", "<s-Tab>", ":bp<cr>", "Previous buffer"}, {"n", "U", ":redo<cr>", "Redo"}, {"n", "ge", ":e <cfile><cr>", "Open file under cursor"}, {"n", ",,", ":e#<cr>", "Switch between alternate buffers"}, {"n", "<leader>P", "<cmd>ParinferToggle<cr>", "Toggle Parinfer"}, {"n", "<leader>lT", "<cmd>TodoTelescope<cr>", "Todos"}, {"n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "TypeScript Type"}, {"n", "<leader>lw", "<cmd>TailwindConcealToggle<cr>", "Tailwind Conceal Toggle"}, {"n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"}, {"n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", "Code Definition"}, {"n", "<leader>li", "<cmd>Telescope import<cr>", "Add Import"}, {"n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"}, {"n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", "References"}, {"n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"}, {"n", "<leader>lI", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<cr>", "Diagnostic"}, {"n", "<leader>gg", "<cmd>wa<cr><cmd>Neogit<cr>", "Neogit"}, {"n", "<leader>gb", "<cmd>Telescope git_branches<cr>", "Checkout branch"}, {"n", "<leader>gc", "<cmd>Telescope git_commits<cr>", "Checkout commit"}, {"n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", "Checkout commit"}, {"n", "<leader>gt", "<cmd>Tardis<cr>", "Open Tardis"}, {"n", "<leader>go", "<cmd>Telescope git_status<cr>", "Open changed file"}, {"n", "<leader>gv", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk"}, {"n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk"}, {"n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk"}, {"n", "<leader>gU", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk"}, {"n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer"}, {"n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr><cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Next Hunk"}, {"n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr><cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Prev Hunk"}, {"n", "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame"}, {"n", "<leader>MM", "<cmd>RenderMarkdown toggle<cr>", "Toggle Render-Markdown"}, {"n", "<leader>tn", ":tabnew<CR>", "New Tab"}, {"n", "<leader>tc", ":tabclose<CR>", "Close Tab"}, {"n", "<leader>to", ":tabonly<CR>", "Close Other Tabs"}, {"n", "<leader>th", ":tabprevious<CR>", "Previous Tab"}, {"n", "<leader>tl", ":tabnext<CR>", "Next Tab"}, {"n", "\203\153", "<C-W><C-H>", "Window navigation"}, {"n", "\194\172", "<C-W><C-L>", "Window navigation"}, {"n", "\226\136\134", "<C-W><C-J>", "Window navigation"}, {"n", "\203\154", "<C-W><C-K>", "Window navigation"}, {"n", "\195\184", "<C-W><C-O>", "Window only"}, {"n", "\195\159", "<C-W><C-S>", "Window split"}, {"n", "\226\136\154", "<C-W><C-V>", "Window split vertically"}, {"n", "\195\167", "<C-W>c", "Window close"}, {"n", "<enter>", "<cmd>Telescope buffers<cr>", "Buffers"}, {"n", "<space>a", "<cmd>Telescope ast_grep<cr>", "AST Grep"}, {"n", "<space>R", "<cmd>GrugFar<cr>", "Grug Far"}, {"v", "<space>R", ":'<,'>GrugFar<cr>", "Grug Far"}, {"n", "<space>y", "<cmd>Telescope neoclip<cr>", "Yank History"}, {"n", "<space>f", ":lua require('telescope.builtin').find_files()<CR>", "Find Files"}, {"n", "<space>F", "<cmd>:lua MiniFiles.open(vim.uv.cwd(), true)<CR>", "Explore"}, {"n", "<space>d", "<cmd>Telescope oil<CR>", "Explore Directory"}, {"n", "<space>g", ":lua require('user.telescope-multigrep').multigrep()<CR>", "Multigrep (with `  `)"}, {"n", "<space>w", "<cmd>Telescope grep_string<cr>", "Find Current Word"}, {"n", "<space>m", "<cmd>Telescope macroscope<cr>", "Macro History"}, {"n", "<space>s", "<cmd>Telescope sessions_picker<cr>", "Sessions"}, {"n", "<space>h", ":lua require('telescope.builtin').help_tags(require('telescope.themes').get_ivy())<CR>", "Help Tags"}, {"n", "<space>b", "<cmd>Telescope builtin<cr>", "Builtin"}, {"n", "<space>r", ":lua require('telescope.builtin').resume()<CR>", "Resume last search"}, {"n", "<space>e", ":lua require('telescope.builtin').live_grep({additional_args = function() return {'--fixed-strings'} end})<CR>", "Search Exact String"}, {"v", "<", "<gv", "Visualmode indent"}, {"v", ">", ">gv", "Visualmode indent"}}
local function add_mapping(wk, _8_)
  local mode = _8_[1]
  local key = _8_[2]
  local mapping = _8_[3]
  local desc = _8_[4]
  return wk.add({{key, mapping, desc = desc, mode = mode}})
end
local function add_group(wk, _9_)
  local prefix = _9_[1]
  local group = _9_[2]
  return wk.add({{prefix, group = group}})
end
local function add_groups_and_mappings()
  local wk = require("which-key")
  local function _10_(_241)
    return add_group(wk, _241)
  end
  core.map(_10_, groups)
  local function _11_(_241)
    return add_mapping(wk, _241)
  end
  return core.map(_11_, mappings)
end
return {"folke/which-key.nvim", config = add_groups_and_mappings}
