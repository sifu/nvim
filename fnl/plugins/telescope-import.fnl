{1 "piersolenski/telescope-import.nvim"
 :dependencies ["nvim-telescope/telescope.nvim"]
 :config (fn []
           (let [telescope (require "telescope")]
             (telescope.load_extension "import")))}
