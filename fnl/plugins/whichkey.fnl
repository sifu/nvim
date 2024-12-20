(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

;; cmdline emacs keys did not work with which-key so add them with vim.keymap.set:
(vim.keymap.set "c" "<c-a>" "<home>" {:noremap true})
(vim.keymap.set "c" "<c-b>" "<left>" {:noremap true})
(vim.keymap.set "c" "<c-d>" "<del>" {:noremap true})
(vim.keymap.set "c" "<c-e>" "<end>" {:noremap true})
(vim.keymap.set "c" "<c-f>" "<right>" {:noremap true})
(vim.keymap.set "c" "<c-n>" "<down>" {:noremap true})
(vim.keymap.set "c" "<c-p>" "<up>" {:noremap true})

(local groups [["<leader>g" "Git"]
               ["<leader>l" "LSP"]
               ["<leader>a" "Avante/ChatGPT"]
               ["<leader>ac" "ChatGPT"]
               ["<leader>c" "Conjure"]
               ["<leader>s" "SQL"]
               ["<leader>t" "Tabs"]
               ["<leader>M" "Markdown"]
               ["<space>" "Search"]
               ["ga" "Change Text Case"]])

(fn show-help []
  (let [wk (require "which-key")] (wk.show)))

(fn enter []
  (let [buf (vim.api.nvim_get_current_buf)
        ft (vim.api.nvim_buf_get_option buf "filetype")]
    (if (= ft "qf") (vim.cmd ".cc") (vim.cmd "Telescope buffers"))))

(local mappings [;; misc
                 ["n"
                  "yc"
                  "yy<cmd>normal gcc<CR>p"
                  "Copy line and comment out original"]
                 ["n" "gp" "`[v`]" "Select last changed text"]
                 ["n" "<c-d>" "<c-d>zz" "Down half a page"]
                 ["n" "<c-u>" "<c-u>zz" "Up half a page"]
                 ["n" "<esc>" ":noh<cr><esc>" "Clear Highlightsearch"]
                 ["i" "<c-bs>" "<c-w>" "Delete word"]
                 ["i" "<c-h>" "<c-w>" "Delete word"]
                 ["i"
                  "<c-a>"
                  "<esc>?<<cr>:noh<cr>ea<space>"
                  "Add property to tag"]
                 ["i" "<c-t>" "<esc>/++<cr>cf+" "Replace next marker"]
                 ["n" "<c-t>" "/++<cr>cf+" "Replace next marker"]
                 ["n" "<c-p>" "/><cr>:noh<cr>a" "Insert inside tag"]
                 ["n" "<leader>?" show-help "Help"]
                 ["n" "<leader><leader>" ":wa<cr>" "Write all"]
                 ["i" "<leader><leader>" "<esc>:wa<cr>" "Write all"]
                 ["n" "<leader>q" ":qa<cr>" "Quit"]
                 ["n" "<leader>d" ":bd<cr>" "Delete buffer"]
                 ["n" "<leader>p" "<cmd>Lazy update<cr>" "Update packages"]
                 ["n" "<leader>x" ":wa<cr>:!%:p<cr>" "Execute file"]
                 ["n"
                  "<leader>T"
                  ":!tmux bind t new-window -c $(pwd)<cr>"
                  "Set Tmux to CWD"]
                 ["n" "<leader>o" ":!open %<cr>" "Open file"]
                 ["n" "<leader>O" ":!open .<cr>" "Open directory"]
                 ["n"
                  "-"
                  ":lua require('oil').open_float()<cr>"
                  "Open Parent Directory"]
                 ["n" "<Tab>" ":bn<cr>" "Next buffer"]
                 ["n" "<s-Tab>" ":bp<cr>" "Previous buffer"]
                 ["n" "U" ":redo<cr>" "Redo"]
                 ["n" "ge" ":e <cfile><cr>" "Open file under cursor"]
                 ["n" ",," ":e#<cr>" "Switch between alternate buffers"]
                 ["n" "<leader>P" "<cmd>ParinferToggle<cr>" "Toggle Parinfer"]
                 ;; LSP
                 ; not really a lsp thingy, but I think it fits
                 ["n" "<leader>lt" "<cmd>TodoTelescope<cr>" "Todos"]
                 ["n"
                  "<leader>la"
                  "<cmd>lua vim.lsp.buf.code_action()<cr>"
                  "Code Action"]
                 ["n"
                  "<leader>ld"
                  "<cmd>Telescope lsp_definitions<cr>"
                  "Code Definition"]
                 ["n" "<leader>li" "<cmd>Telescope import<cr>" "Add Import"]
                 ["n"
                  "<leader>lR"
                  "<cmd>lua vim.lsp.buf.rename()<cr>"
                  "Rename"]
                 ["n"
                  "<leader>lr"
                  "<cmd>Telescope lsp_references<cr>"
                  "References"]
                 ["n"
                  "<leader>ls"
                  "<cmd>Telescope lsp_document_symbols<cr>"
                  "Document Symbols"]
                 ["n"
                  "<leader>lI"
                  "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })<cr>"
                  "Diagnostic"]
                 ["n"
                  "<leader>lp"
                  "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<cr>"
                  "Diagnostic"]
                 ["n"
                  "<leader>ln"
                  "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<cr>"
                  "Diagnostic"]
                 ;; Git
                 ["n" "<leader>gg" "<cmd>Neogit<cr>" "Neogit"]
                 ["n"
                  "<leader>gb"
                  "<cmd>Telescope git_branches<cr>"
                  "Checkout branch"]
                 ["n"
                  "<leader>gc"
                  "<cmd>Telescope git_commits<cr>"
                  "Checkout commit"]
                 ["n"
                  "<leader>gC"
                  "<cmd>Telescope git_bcommits<cr>"
                  "Checkout commit"]
                 ["n" "<leader>gt" "<cmd>Tardis<cr>" "Open Tardis"]
                 ["n"
                  "<leader>go"
                  "<cmd>Telescope git_status<cr>"
                  "Open changed file"]
                 ["n"
                  "<leader>gv"
                  "<cmd>lua require 'gitsigns'.preview_hunk()<cr>"
                  "Preview Hunk"]
                 ["n"
                  "<leader>gr"
                  "<cmd>lua require 'gitsigns'.reset_hunk()<cr>"
                  "Reset Hunk"]
                 ["n"
                  "<leader>gs"
                  "<cmd>lua require 'gitsigns'.stage_hunk()<cr>"
                  "Stage Hunk"]
                 ["n"
                  "<leader>gU"
                  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>"
                  "Undo Stage Hunk"]
                 ["n"
                  "<leader>gR"
                  "<cmd>lua require 'gitsigns'.reset_buffer()<cr>"
                  "Reset Buffer"]
                 ["n"
                  "<leader>gj"
                  "<cmd>lua require 'gitsigns'.next_hunk()<cr><cmd>lua require 'gitsigns'.preview_hunk()<cr>"
                  "Next Hunk"]
                 ["n"
                  "<leader>gk"
                  "<cmd>lua require 'gitsigns'.prev_hunk()<cr><cmd>lua require 'gitsigns'.preview_hunk()<cr>"
                  "Prev Hunk"]
                 ["n"
                  "<leader>gl"
                  "<cmd>lua require 'gitsigns'.blame_line()<cr>"
                  "Blame"]
                 ;; Markdown
                 ["n"
                  "<leader>MM"
                  "<cmd>RenderMarkdown toggle<cr>"
                  "Toggle Render-Markdown"]
                 ;; SQL
                 ;; Tabs
                 ["n" "<leader>tn" ":tabnew<CR>" "New Tab"]
                 ["n" "<leader>tc" ":tabclose<CR>" "Close Tab"]
                 ["n" "<leader>to" ":tabonly<CR>" "Close Other Tabs"]
                 ["n" "<leader>th" ":tabprevious<CR>" "Previous Tab"]
                 ["n" "<leader>tl" ":tabnext<CR>" "Next Tab"]
                 ;; Window Movements
                 ["n" "˙" "<C-W><C-H>" "Window navigation"]
                 ["n" "¬" "<C-W><C-L>" "Window navigation"]
                 ["n" "∆" "<C-W><C-J>" "Window navigation"]
                 ["n" "˚" "<C-W><C-K>" "Window navigation"]
                 ["n" "ø" "<C-W><C-O>" "Window only"]
                 ["n" "ß" "<C-W><C-S>" "Window split"]
                 ["n" "√" "<C-W><C-V>" "Window split vertically"]
                 ["n" "ç" "<C-W>c" "Window close"]
                 ;; Telescope
                 ["n" "<enter>" "<cmd>Telescope buffers<cr>" "Buffers"]
                 ["n" "<space>y" "<cmd>Telescope neoclip<cr>" "Yank History"]
                 ["n"
                  "<space>f"
                  ":lua require('telescope.builtin').find_files()<CR>"
                  "Find Files"]
                 ["n" "<space>d" "<cmd>Telescope oil<cr>" "Find Directories"]
                 ["n"
                  "<space>g"
                  ":lua require('user.telescope-multigrep').multigrep()<CR>"
                  "Multigrep (with `  `)"]
                 ["n"
                  "<space>w"
                  "<cmd>Telescope grep_string<cr>"
                  "Find Current Word"]
                 ["n"
                  "<space>m"
                  "<cmd>Telescope macroscope<cr>"
                  "Macro History"]
                 ["n"
                  "<space>s"
                  "<cmd>Telescope sessions_picker<cr>"
                  "Sessions"]
                 ["n"
                  "<space>h"
                  ":lua require('telescope.builtin').help_tags(require('telescope.themes').get_ivy())<CR>"
                  "Help Tags"]
                 ["n" "<space>b" "<cmd>Telescope builtin<cr>" "Builtin"]
                 ["n"
                  "<space>r"
                  ":lua require('telescope.builtin').resume()<CR>"
                  "Resume last search"]
                 ;; Visual Mappings
                 ["v" "<" "<gv" "Visualmode indent"]
                 ["v" ">" ">gv" "Visualmode indent"]])

(fn add-mapping [wk [mode key mapping desc]]
  (wk.add [{1 key 2 mapping : desc : mode}]))

(fn add-group [wk [prefix group]]
  (wk.add [{1 prefix : group}]))

(fn add-groups-and-mappings []
  (let [wk (require "which-key")]
    (core.map #(add-group wk $1) groups)
    (core.map #(add-mapping wk $1) mappings)))

{1 "folke/which-key.nvim" :config add-groups-and-mappings}
