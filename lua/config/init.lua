-- [nfnl] Compiled from fnl/config/init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
vim.keymap.set("n", "\226\130\172", "<nop>", {noremap = true})
require("config.keymaps")
do
  local options = {background = "light", signcolumn = "yes", termguicolors = true, cursorline = true, hidden = true, autoindent = true, backspace = "indent,eol,start", viewoptions = "options,cursor", undodir = "/s/.config/nvim/undodir", undofile = true, formatoptions = "cro", wildmode = "longest,list,full", scrolloff = 3, sidescrolloff = 5, sidescroll = 1, display = "lastline", history = 1000, tabpagemax = 50, relativenumber = true, splitright = true, splitbelow = true, textwidth = 100, showbreak = "  ", breakindent = true, smarttab = true, expandtab = true, tabstop = 2, shiftwidth = 2, ignorecase = true, updatetime = 250, smartcase = true, smartindent = true, spelllang = "en_us,de_at", autoread = true, hlsearch = false, wrap = false}
  for option, value in pairs(options) do
    core.assoc(vim.o, option, value)
  end
end
vim.opt.iskeyword:append("-")
vim.opt.listchars:append("precedes:<,extends:>,eol:\194\172,trail:.,nbsp:.")
vim.opt.complete:remove("i")
vim.opt.nrformats:remove("octal")
return {}
