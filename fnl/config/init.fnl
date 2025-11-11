(local {: autoload} (require "nfnl.module"))

(local core (autoload "nfnl.core"))

;; € is reserved to be lead
(vim.keymap.set "n" "€" "<nop>" {:noremap true})

(require "config.gitcommit")
(require "config.javascriptreact")
(require "config.markdown")
(require "config.mdx")
(require "config.rm")
(require "config.session-load")
(require "config.session-sharing")
(require "user.html-to-jsx")
(require "user.timelog")
(require "user.open-file-with-line-number")
(require "user.qf-improvements")

;; ## Misc auto commands

;; Resize all splits when the terminal is resized
(vim.api.nvim_create_autocmd "VimResized" {:command "wincmd ="})

;; Don't continue commenting on new line
(vim.api.nvim_create_autocmd "FileType"
                             {:group (vim.api.nvim_create_augroup "no_auto_comment"
                                                                  {})
                              :callback (fn []
                                          (vim.opt_local.formatoptions:remove ["c"
                                                                               "r"
                                                                               "o"]))})

;; sets a nvim global options
(let [options {:background "light"
               :termguicolors true
               :cursorline true
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
               :number true
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
               :signcolumn "yes"
               :hlsearch true
               :ignorecase true
               :updatetime 250
               :smartcase true
               :smartindent true
               :spelllang "en_us,de_at"
               :autoread true
               :foldenable false}]
  (each [option value (pairs options)]
    (core.assoc vim.o option value)))

(vim.opt.iskeyword:append "-")
(vim.opt.listchars:append "precedes:<,extends:>,eol:¬,trail:.,nbsp:.")
(vim.opt.complete:remove "i")
(vim.opt.nrformats:remove "octal")

{}
