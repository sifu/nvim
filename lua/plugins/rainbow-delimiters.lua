-- [nfnl] fnl/plugins/rainbow-delimiters.fnl
local file_types = {"clojure", "scheme", "lisp", "fennel", "janet"}
local strategy
do
  local tbl_21_ = {}
  for _, ft in ipairs(file_types) do
    local k_22_, v_23_ = ft, "rainbow-delimiters.strategy.global"
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  strategy = tbl_21_
end
local query
do
  local tbl_21_ = {}
  for _, ft in ipairs(file_types) do
    local k_22_, v_23_ = ft, "rainbow-delimiters"
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  query = tbl_21_
end
local function _3_()
  local function _4_()
  end
  local function _5_()
  end
  vim.g.rainbow_delimiters = {strategy = vim.tbl_extend("force", {[""] = _4_}, strategy), query = vim.tbl_extend("force", {[""] = _5_}, query), highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue", "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan"}}
  return nil
end
return {{"HiPhish/rainbow-delimiters.nvim", ft = file_types, config = _3_}}
