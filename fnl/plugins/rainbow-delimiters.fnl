[{1 "HiPhish/rainbow-delimiters.nvim"
  :ft ["clojure" "scheme" "lisp" "janet"]
  :config (fn []
            (set vim.g.rainbow_delimiters
                 {:strategy {:scheme "rainbow-delimiters.strategy.global"
                             :lisp "rainbow-delimiters.strategy.global"
                             :clojure "rainbow-delimiters.strategy.global"
                             :janet "rainbow-delimiters.strategy.global"}
                  :query {:scheme "rainbow-delimiters"
                          :lisp "rainbow-delimiters"
                          :clojure "rainbow-delimiters"
                          :janet "rainbow-delimiters"}
                  :highlight ["RainbowDelimiterRed"
                              "RainbowDelimiterYellow"
                              "RainbowDelimiterBlue"
                              "RainbowDelimiterOrange"
                              "RainbowDelimiterGreen"
                              "RainbowDelimiterViolet"
                              "RainbowDelimiterCyan"]}))}]
