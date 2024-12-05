{1 "nvim-treesitter/nvim-treesitter"
 :dependencies ["nvim-treesitter/nvim-treesitter-textobjects"]
 :build ":TSUpdate"
 :opts {:highlight {:enable true
                    :indent {:enable true}
                    :ensure_installed ["bash"
                                       "clojure"
                                       "commonlisp"
                                       "dockerfile"
                                       "fennel"
                                       "html"
                                       "java"
                                       "javascript"
                                       "json"
                                       "lua"
                                       "markdown"
                                       "yaml"]}}}
