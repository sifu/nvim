-- [nfnl] fnl/plugins/rainbow-delimiters.fnl
local function _1_()
  vim.g.rainbow_delimiters = {strategy = {scheme = "rainbow-delimiters.strategy.global", lisp = "rainbow-delimiters.strategy.global", clojure = "rainbow-delimiters.strategy.global", janet = "rainbow-delimiters.strategy.global"}, query = {scheme = "rainbow-delimiters", lisp = "rainbow-delimiters", clojure = "rainbow-delimiters", janet = "rainbow-delimiters"}, highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue", "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan"}}
  return nil
end
return {{"HiPhish/rainbow-delimiters.nvim", ft = {"clojure", "scheme", "lisp", "janet"}, config = _1_}}
