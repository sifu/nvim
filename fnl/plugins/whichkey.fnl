(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(local groups [["<leader>g" "Git"] ["<leader>c" "Conjure"]])

(local mappings [["n" "<leader><leader>" ":wa<cr>" "Write all"]
                 ["n" "<leader>q" ":qa<cr>" "Quit"]
                 ["n" "<leader>d" ":bd<cr>" "Delete buffer"]
                 ["n"
                  "-"
                  ":lua require('oil').open_float()<cr>"
                  "Open Parent Directory"]
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
