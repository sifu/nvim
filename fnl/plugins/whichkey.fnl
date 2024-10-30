[{1 :folke/which-key.nvim
  :event :VeryLazy
  :keys [{1 :<leader><leader> 2 ":wa<cr>" :desc "Write all"}
         {1 :<leader>q 2 ":qa<cr>" :desc :Quit}
         {1 :<leader>d 2 ":bd<cr>" :desc "Delete buffer"}
         {1 "-"
          2 ":lua require('oil').open_float()<cr>"
          :desc "Open Parent Directory"}
         {1 :g
          2 "y:!open 'https://www.google.com/search?q=<c-r>\"'<cr>"
          :mode :v}]}]

;; how do write this in lua (not using numbers)
; {
; -- Nested mappings are allowed and can be added in any order
; -- Most attributes can be inherited or overridden on any level
; -- There's no limit to the depth of nesting
; mode = { "n", "v" }, -- NORMAL and VISUAL mode
; { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
; { "<leader>w", "<cmd>w<cr>", desc = "Write" },
; }
