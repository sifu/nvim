{1 "ThePrimeagen/refactoring.nvim"
 :dependencies ["nvim-lua/plenary.nvim" "nvim-treesitter/nvim-treesitter"]
 :config (fn []
           (let [refactoring (require "refactoring")
                 telescope (require "telescope")]
             (refactoring.setup {})
             (telescope.load_extension "refactoring")))
 :keys [{1 "<leader>re"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Extract Function")))
         :mode ["x"]
         :desc "Extract Function"}
        {1 "<leader>rf"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Extract Function To File")))
         :mode ["x"]
         :desc "Extract Function To File"}
        {1 "<leader>rv"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Extract Variable")))
         :mode ["x"]
         :desc "Extract Variable"}
        {1 "<leader>rI"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Inline Function")))
         :mode ["n"]
         :desc "Inline Function"}
        {1 "<leader>ri"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Inline Variable")))
         :mode ["n" "x"]
         :desc "Inline Variable"}
        {1 "<leader>rbb"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Extract Block")))
         :mode ["n"]
         :desc "Extract Block"}
        {1 "<leader>rbf"
         2 (fn []
             (let [refactoring (require "refactoring")]
               (refactoring.refactor "Extract Block To File")))
         :mode ["n"]
         :desc "Extract Block To File"}]}
