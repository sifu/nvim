{1 "nvim-treesitter/nvim-treesitter"
 :branch "main"
 :dependencies [{1 "nvim-treesitter/nvim-treesitter-textobjects"
                 :branch "main"}]
 :build ":TSUpdate"
 :config (fn []
           (let [ts (require "nvim-treesitter")]
             (ts.install ["bash"
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
                          "yaml"])))}
