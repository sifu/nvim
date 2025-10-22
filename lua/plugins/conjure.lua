-- [nfnl] fnl/plugins/conjure.fnl
local function _1_()
  vim.g["conjure#mapping#prefix"] = ","
  vim.g["conjure#mapping#doc_word"] = "K"
  return nil
end
return {"Olical/conjure", ft = {"fennel", "clojure", "janet", "javascript"}, branch = "main", init = _1_}
