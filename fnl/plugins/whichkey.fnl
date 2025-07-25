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
               ["<leader>C" "Copy Filepath"]
               ["<space>" "Search"]
               ["ga" "Change Text Case"]])

;; disable the <enter> key in the command window `q:`
(vim.api.nvim_create_autocmd "CmdwinEnter"
                             {:callback (fn []
                                          (vim.keymap.set "n" "<enter>" "<Nop>"
                                                          {:buffer true}))})

(fn show-help []
  (let [wk (require "which-key")] (wk.show)))

(fn add-to-obsidian-inbox []
  (let [filename (vim.fn.input "Title: (without .md) " "" "file")]
    (when (not= filename "")
      (vim.cmd (.. ":split /s/Obsidian/Main/Inbox/" filename ".md")))))

(fn copy-filepath-with-line []
  (let [filepath (vim.fn.expand "%")
        line-number (vim.fn.line ".")
        filepath-with-line (.. "@" filepath " on line " line-number)]
    (vim.fn.setreg "+" filepath-with-line)
    (vim.notify (.. "Copied: " filepath-with-line))))

(fn copy-filepath []
  (let [filepath (vim.fn.expand "%")
        prefixed (.. "@" filepath)]
    (vim.fn.setreg "+" prefixed)
    (vim.notify (.. "Copied: " prefixed))))

(fn copy-word-with-filepath []
  (let [word (vim.fn.expand "<cword>")
        filepath (vim.fn.expand "%:p")
        line-number (vim.fn.line ".")
        word-with-filepath (.. word " (@" filepath " on line " line-number ")")]
    (vim.fn.setreg "+" word-with-filepath)
    (vim.notify (.. "Copied: " word-with-filepath))))

(fn copy-filepath-with-line-range []
  (let [filepath (vim.fn.expand "%")
        start-line (. (vim.fn.getpos "v") 2)
        end-line (vim.fn.line ".")
        filepath-with-range (.. "@" filepath " line " start-line " to "
                                end-line)]
    (vim.fn.setreg "+" filepath-with-range)
    (vim.notify (.. "Copied: " filepath-with-range))))

(local mappings [;; misc
                 ["n" ";i" add-to-obsidian-inbox "Add to Obsidian Inbox"]
                 ["n"
                  "<leader>Cc"
                  copy-filepath-with-line
                  "Copy current filepath with line number"]
                 ["n" "<leader>CC" copy-filepath "Copy current filepath"]
                 ["n"
                  "<leader>Cw"
                  copy-word-with-filepath
                  "Copy word under cursor with filepath and line number"]
                 ["v"
                  "<leader>Cr"
                  copy-filepath-with-line-range
                  "Copy filepath with line range"]
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
                 ["n"
                  "<leader>p"
                  ":!git pull<cr><cmd>MasonUpdate<cr><cmd>Lazy update<cr>"
                  "Update packages"]
                 ["n" "<leader>x" ":wa<cr>:!%:p<cr>" "Execute file"]
                 ["n"
                  "<leader>T"
                  ":!tmux bind t new-window -c $(pwd)<cr><cr>"
                  "Set Tmux to CWD"]
                 ["n" "<leader>o" ":!open %<cr>" "Open file"]
                 ["n" "<leader>O" ":!open %:p:h<cr>" "Open directory"]
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
                 ["n" "<leader>lT" "<cmd>TodoTelescope<cr>" "Todos"]
                 ["n"
                  "<leader>lt"
                  "<cmd>lua vim.lsp.buf.type_definition()<cr>"
                  "TypeScript Type"]
                 ["n"
                  "<leader>lw"
                  "<cmd>TailwindConcealToggle<cr>"
                  "Tailwind Conceal Toggle"]
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
                 ["n" "<leader>gg" "<cmd>wa<cr><cmd>Neogit<cr>" "Neogit"]
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
                  "<space>t"
                  "<cmd>Telescope tailiscope<cr>"
                  "Tailwind cheatsheet"]
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
