(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

;; Make j and k work as I would expect in case line wrap is enabled
(vim.keymap.set "n" "k"
                (fn []
                  (if (= vim.v.count 0) "gk" "k")) {:expr true})

(vim.keymap.set "n" "j"
                (fn []
                  (if (= vim.v.count 0) "gj" "j")) {:expr true})

;; cmdline emacs keys did not work with which-key so add them with vim.keymap.set:
(vim.keymap.set "c" "<c-a>" "<home>" {:noremap true})
(vim.keymap.set "c" "<c-b>" "<left>" {:noremap true})
(vim.keymap.set "c" "<c-d>" "<del>" {:noremap true})
(vim.keymap.set "c" "<c-e>" "<end>" {:noremap true})
(vim.keymap.set "c" "<c-f>" "<right>" {:noremap true})
(vim.keymap.set "c" "<c-n>" "<down>" {:noremap true})
(vim.keymap.set "c" "<c-p>" "<up>" {:noremap true})

;; this did not work with which-key so add them with vim.keymap.set:
(vim.keymap.set "n" "<leader>e" ":E<space>" {:noremap true})

(local groups [["<leader>g" "Git"]
               ["<leader>l" "LSP"]
               ["<leader>a" "ChatGPT"]
               ["<leader>s" "SQL"]
               ["<leader>t" "Tabs"]
               ["<leader>M" "Markdown"]
               ["<leader>c" "Copy Filepath"]
               ["<space>" "Search"]
               ["ga" "Change Text Case"]])

;; disable our default <enter> key mapping in the command window `q:`
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

(fn copy-and-notify [text]
  (vim.cmd "silent! wa")
  (vim.fn.setreg "+" text)
  (vim.notify (.. "Copied: " text))
  text)

(fn copy-filepath-with-line []
  (let [filepath (vim.fn.expand "%")
        line-number (vim.fn.line ".")
        filepath-with-line (.. "@" filepath " on line " line-number)]
    (copy-and-notify filepath-with-line)))

(fn copy-file-reference []
  (let [filepath (vim.fn.expand "%:p")
        line-number (vim.fn.line ".")
        filepath-with-line (.. filepath ":" line-number)]
    (copy-and-notify filepath-with-line)))

(fn copy-filepath-raw []
  (copy-and-notify (vim.fn.expand "%:p")))

(fn copy-filepath []
  (let [filepath (vim.fn.expand "%")
        prefixed (.. "@" filepath)]
    (copy-and-notify prefixed)))

(fn copy-word-with-filepath []
  (let [word (vim.fn.expand "<cword>")
        filepath (vim.fn.expand "%:p")
        line-number (vim.fn.line ".")
        word-with-filepath (.. "`" word "` (@" filepath " on line " line-number
                               ")")]
    (copy-and-notify word-with-filepath)))

(fn show-in-popup [lines]
  (let [buf (vim.api.nvim_create_buf false true)
        width (math.min 100 (- vim.o.columns 4))
        height (math.min (+ (length lines) 2) (- vim.o.lines 4))
        row (math.floor (/ (- vim.o.lines height) 2))
        col (math.floor (/ (- vim.o.columns width) 2))]
    (vim.api.nvim_open_win buf true
                           {:relative "editor"
                            : width
                            : height
                            : row
                            : col
                            :style "minimal"
                            :border "rounded"
                            :title " i18n Translation "
                            :title_pos "center"})
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (vim.api.nvim_set_option_value "modifiable" false {: buf})
    (vim.api.nvim_set_option_value "bufhidden" "wipe" {: buf})
    (vim.keymap.set "n" "q" "<cmd>close<cr>" {:buffer buf})
    (vim.keymap.set "n" "<esc>" "<cmd>close<cr>" {:buffer buf})))

(fn find-i18n-key []
  (vim.cmd "normal! yi'")
  (let [key (vim.fn.getreg "\"")]
    (when (and key (not= key ""))
      (vim.fn.setreg "+" key)
      (let [output (vim.fn.system (.. "/Users/sifu/.claude/skills/find-i18n/find-i18n.sh "
                                      (vim.fn.shellescape key)))
            lines (vim.split output "\n" {:trimempty true})]
        (show-in-popup lines)))))

(fn copy-filepath-with-line-range []
  (let [filepath (vim.fn.expand "%")
        start-line (. (vim.fn.getpos "v") 2)
        end-line (vim.fn.line ".")
        sorted-start (math.min start-line end-line)
        sorted-end (math.max start-line end-line)
        filepath-with-range (.. "@" filepath " line " sorted-start " to "
                                sorted-end)]
    (copy-and-notify filepath-with-range)))

(local mappings [;; misc
                 ["n"
                  ",S"
                  "<cmd>e /s/tmp/scratchpad.fnl<cr>"
                  "Open Scratchpad"]
                 ["n" ",i" add-to-obsidian-inbox "Add to Obsidian Inbox"]
                 ["n" ",o" "<cmd>Obsidian<cr>" "Open Obsidian"]
                 ["n"
                  ",s"
                  "<cmd>Obsidian quick_switch<cr>"
                  "Obsidian Quick Switch"]
                 ["n" ",n" "<cmd>Obsidian new<cr>" "New Obsidian Note"]
                 ["n" "<leader>u" "<cmd>Atone toggle<cr>" "Undo Tree"]
                 ["n"
                  "<leader>cr"
                  copy-file-reference
                  "Copy current file reference"]
                 ["n"
                  "<leader>cC"
                  copy-filepath-with-line
                  "Copy current filepath with line number"]
                 ["n" "<leader>cc" copy-filepath "Copy current filepath"]
                 ["n"
                  "<leader>cw"
                  copy-word-with-filepath
                  "Copy word under cursor with filepath and line number"]
                 ["v"
                  "<leader>cr"
                  copy-filepath-with-line-range
                  "Copy filepath with line range"]
                 ["n" "<leader>cp" copy-filepath-raw "Copy filepath raw"]
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
                 ["n" "<leader>li" find-i18n-key "Find i18n Translation"]
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
                 ["n" "<leader>lD" "<c-w>]" "Code Definition Split"]
                 ["n"
                  "<leader>lR"
                  "<cmd>lua vim.lsp.buf.rename()<cr>"
                  "Rename"]
                 ["n"
                  "<leader>lr"
                  "<cmd>Telescope lsp_references<cr>"
                  "References"]
                 ["n"
                  "<leader>lf"
                  ":lua require('user.lsp-unique-references').references()<CR>"
                  "References (unique files)"]
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
                 ["n" "<space>a" "<cmd>Telescope ast_grep<cr>" "AST Grep"]
                 ["n" "<space>R" "<cmd>GrugFar<cr>" "Grug Far"]
                 ["v" "<space>R" ":'<,'>GrugFar<cr>" "Grug Far"]
                 ["n" "<space>y" "<cmd>Telescope neoclip<cr>" "Yank History"]
                 ["n"
                  "<space>f"
                  ":lua require('telescope.builtin').find_files()<CR>"
                  "Find Files"]
                 ["n"
                  "<space>F"
                  "<cmd>:lua MiniFiles.open(vim.uv.cwd(), true)<CR>"
                  "Explore"]
                 ["n" "<space>d" "<cmd>Telescope oil<CR>" "Explore Directory"]
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
                 ["n"
                  "<space>e"
                  ":lua require('telescope.builtin').live_grep({additional_args = function() return {'--fixed-strings'} end})<CR>"
                  "Search Exact String"]
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
