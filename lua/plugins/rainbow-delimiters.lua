-- [nfnl] fnl/plugins/rainbow-delimiters.fnl
local file_types = {"clojure", "scheme", "lisp", "fennel", "janet"}
local strategy
do
  local tbl_16_ = {}
  for _, ft in ipairs(file_types) do
    local k_17_, v_18_ = ft, "rainbow-delimiters.strategy.global"
    if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
      tbl_16_[k_17_] = v_18_
    else
    end
  end
  strategy = tbl_16_
end
local query
do
  local tbl_16_ = {}
  for _, ft in ipairs(file_types) do
    local k_17_, v_18_ = ft, "rainbow-delimiters"
    if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
      tbl_16_[k_17_] = v_18_
    else
    end
  end
  query = tbl_16_
end
local function _3_()
  vim.g.rainbow_delimiters = {strategy = strategy, query = query, highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue", "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan"}}
  return nil
end
return {{"HiPhish/rainbow-delimiters.nvim", ft = file_types, config = _3_}}
