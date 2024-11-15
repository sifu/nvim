{1 "debugloop/telescope-undo.nvim"
 :dependencies ["nvim-telescope/telescope.nvim"]
 :keys [{1 "<leader>u" 2 "<cmd>Telescope undo<cr>" 3 "Undo Tree"}]
 :config (fn []
           (let [telescope (require "telescope")]
             (telescope.load_extension "undo")))}
