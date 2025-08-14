{1 "nvim-treesitter/nvim-treesitter"
 :dependencies ["nvim-treesitter/nvim-treesitter-textobjects"]
 :build ":TSUpdate"
 :config (fn []
           (let [ts (require "nvim-treesitter.configs")]
             (ts.setup {:highlight {:enable true}
                        :indent {:enable true}
                        :ensure_installed ["bash"
                                           "clojure"
                                           "commonlisp"
                                           "dockerfile"
                                           "fennel"
                                           "html"
                                           "java"
                                           "javascript"
                                           "typescript"
                                           "tsx"
                                           "json"
                                           "lua"
                                           "markdown"
                                           "yaml"]})))}
