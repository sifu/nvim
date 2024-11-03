(local {: autoload} (require "nfnl.module"))

(local core (autoload "nfnl.core"))

;; € is reserved to be lead
(vim.keymap.set "n" "€" "<nop>" {:noremap true})

;; sets a nvim global options
(let [options {:background "light"
               :termguicolors true
               :cursorline false
               :hidden true
               :autoindent true
               :backspace "indent,eol,start"
               :viewoptions "options,cursor"
               :undodir "/s/.config/nvim/undodir"
               :undofile true
               :formatoptions "cro"
               :wildmode "longest,list,full"
               :scrolloff 3
               :sidescrolloff 5
               :sidescroll 1
               :display "lastline"
               :history 1000
               :tabpagemax 50
               :relativenumber true
               :splitright true
               :splitbelow true
               :textwidth 100
               :showbreak "  "
               :breakindent true
               :wrap false
               :smarttab true
               :expandtab true
               :tabstop 2
               :shiftwidth 2
               :hlsearch false
               :ignorecase true
               :updatetime 250
               :smartcase true
               :smartindent true
               :spelllang "en_us,de_at"
               :autoread true}]
  (each [option value (pairs options)]
    (core.assoc vim.o option value)))

(vim.opt.iskeyword:append "-")
(vim.opt.listchars:append "precedes:<,extends:>,eol:¬,trail:.,nbsp:.")
(vim.opt.complete:remove "i")
(vim.opt.nrformats:remove "octal")

{}
