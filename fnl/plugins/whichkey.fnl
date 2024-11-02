(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(local groups [["<leader>g" "Git"]
               ["<leader>c" "Conjure"]
               ["<leader>a" "AI/ChatGPT"]
               ["ga" "Change Text Case"]])

(fn show-help []
  (let [wk (require "which-key")] (wk.show)))

;; where did the .cc come from? this
; vim.keymap.set("n", "<enter>", function())
;   local buf = vim.api.nvim_get_current_buf()
;   local ft = vim.api.nvim_buf_get_option(buf, "filetype")
;   if ft == "qf" then
;     vim.cmd(".cc")
;   else
;     vim.cmd("Telescope buffers")
;   end
; end

(local mappings [;; Normal Mode Mappings
                 ["n" "<leader>?" show-help "Help"]
                 ["n" "<leader><leader>" ":wa<cr>" "Write all"]
                 ["i" "<leader><leader>" "<esc>:wa<cr>" "Write all"]
                 ["n" "<leader>q" ":qa<cr>" "Quit"]
                 ["n" "<leader>d" ":bd<cr>" "Delete buffer"]
                 ["n" "gp" "`[v`]" "Select last changed text"]
                 ["n"
                  "-"
                  ":lua require('oil').open_float()<cr>"
                  "Open Parent Directory"]
                 ["n" "<Tab>" ":bn<cr>" "Next buffer"]
                 ["n" "<s-Tab>" ":bp<cr>" "Previous buffer"]
                 ["n" "U" ":redo<cr>" "Redo"]
                 ["n" "gf" ":e <cfile><cr>" "Open file under cursor"]
                 ["n" ",," ":e#<cr>" "Switch between alternate buffers"]
                 ["n" "˙" "<C-W><C-H>" "Window navigation"]
                 ["n" "¬" "<C-W><C-L>" "Window navigation"]
                 ["n" "∆" "<C-W><C-J>" "Window navigation"]
                 ["n" "˚" "<C-W><C-K>" "Window navigation"]
                 ["n" "ø" "<C-W><C-O>" "Window only"]
                 ["n" "ß" "<C-W><C-S>" "Window split"]
                 ["n" "√" "<C-W><C-V>" "Window split vertically"]
                 ["n" "ç" "<C-W>c" "Window close"]
                 ;; Telescope
                 ["n"
                  "<enter>"
                  ":lua require('telescope.builtin').buffers()<CR>"
                  "Buffers"]
                 ["n"
                  "<space>f"
                  ":lua require('telescope.builtin').find_files()<CR>"
                  "Find Files"]
                 ["n"
                  "<space>g"
                  ":lua require('telescope.builtin').live_grep()<CR>"
                  "Live Grep"]
                 ["n"
                  "<space>h"
                  ":lua require('telescope.builtin').help_tags()<CR>"
                  "Help Tags"]
                 ["n"
                  "<space>r"
                  ":lua require('telescope.builtin').resume()<CR>"
                  "Resume last search"]
                 ;; Visual Mappings
                 ["v"
                  "<leader>g"
                  "y:!open 'https://www.google.com/search?q=<c-r>\"'<cr>"
                  "Search selection with Google"]])

(fn add-mapping [wk [mode key mapping desc]]
  (wk.add [{1 key 2 mapping : desc : mode}]))

(fn add-group [wk [prefix group]]
  (wk.add [{1 prefix : group}]))

(fn add-groups-and-mappings []
  (let [wk (require "which-key")]
    (core.map #(add-group wk $1) groups)
    (core.map #(add-mapping wk $1) mappings)))

[{1 "folke/which-key.nvim" :config add-groups-and-mappings}]
