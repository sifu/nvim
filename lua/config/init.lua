-- [nfnl] fnl/config/init.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
vim.keymap.set("n", "\226\130\172", "<nop>", {noremap = true})
require("config.gitcommit")
require("config.javascriptreact")
require("config.json")
require("config.markdown")
require("config.mdx")
require("config.babashka")
require("config.rm")
require("config.session-load")
require("config.session-sharing")
require("user.html-to-jsx")
require("user.timelog")
require("user.open-file-with-line-number")
require("user.qf-improvements")
vim.api.nvim_create_autocmd("VimResized", {command = "wincmd ="})
local function _2_()
  return vim.opt_local.formatoptions:remove({"c", "r", "o"})
end
vim.api.nvim_create_autocmd("FileType", {group = vim.api.nvim_create_augroup("no_auto_comment", {}), callback = _2_})
do
  local options = {background = "light", termguicolors = true, cursorline = true, hidden = true, autoindent = true, backspace = "indent,eol,start", viewoptions = "options,cursor", undodir = "/s/.config/nvim/undodir", undofile = true, formatoptions = "cro", wildmode = "longest,list,full", scrolloff = 3, sidescrolloff = 5, sidescroll = 1, display = "lastline", history = 1000, tabpagemax = 50, number = true, relativenumber = true, splitright = true, splitbelow = true, textwidth = 100, showbreak = "  ", breakindent = true, smarttab = true, expandtab = true, tabstop = 2, shiftwidth = 2, signcolumn = "yes", hlsearch = true, ignorecase = true, updatetime = 250, smartcase = true, smartindent = true, spelllang = "en_us,de_at", autoread = true, foldenable = false, wrap = false}
  for option, value in pairs(options) do
    core.assoc(vim.o, option, value)
  end
end
vim.opt.iskeyword:append("-")
vim.opt.listchars:append("precedes:<,extends:>,eol:\194\172,trail:.,nbsp:.")
vim.opt.complete:remove("i")
vim.opt.nrformats:remove("octal")
return {}
