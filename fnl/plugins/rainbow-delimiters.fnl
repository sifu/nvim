(local file-types ["clojure" "scheme" "lisp" "fennel" "janet"])

(local strategy
       (collect [_ ft (ipairs file-types)]
         (values ft "rainbow-delimiters.strategy.global")))
(local query (collect [_ ft (ipairs file-types)]
               (values ft "rainbow-delimiters")))

[{1 "HiPhish/rainbow-delimiters.nvim"
  :ft file-types
  :config (fn []
            (set vim.g.rainbow_delimiters
                 {: strategy
                  : query
                  :highlight ["RainbowDelimiterRed"
                              "RainbowDelimiterYellow"
                              "RainbowDelimiterBlue"
                              "RainbowDelimiterOrange"
                              "RainbowDelimiterGreen"
                              "RainbowDelimiterViolet"
                              "RainbowDelimiterCyan"]}))}]
