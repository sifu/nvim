[{1 "chrishrb/gx.nvim"
  :keys [{1 "gx" 2 "<cmd>Browse<cr>" :mode ["n" "x"]}]
  :cmd ["Browse"]
  :init (fn [] (set vim.g.netrw_nogx 1))
  :dependencies ["nvim-lua/plenary.nvim"]
  :submodules false
  :opts {:handlers {:nvim-fennel {:name "nvim-fennel"
                                  :filetype ["fennel"]
                                  :handle (fn [mode line _]
                                            (let [helper (require "gx.helper")
                                                  pattern "[\"']([^%s~/]*/[^%s~/]*)[\"']"
                                                  username-repo (helper.find line
                                                                             mode
                                                                             pattern)]
                                              (when username-repo
                                                (.. "https://github.com/"
                                                    username-repo))))}}}}]
