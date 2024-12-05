{1 "nvim-treesitter/nvim-treesitter"
 :dependencies ["nvim-treesitter/nvim-treesitter-textobjects"]
 :build ":TSUpdate"
 :config (fn []
           (let [treesitter (require "nvim-treesitter.configs")]
             (treesitter.setup {:highlight {:enable true}
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
                                                   "yaml"]})))}
