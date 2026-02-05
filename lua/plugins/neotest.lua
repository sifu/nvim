-- [nfnl] fnl/plugins/neotest.fnl
local function _1_()
  local neotest = require("neotest")
  local vitest = require("neotest-vitest")
  local function _2_(name)
    return (name ~= "node_modules")
  end
  neotest.setup({adapters = {vitest({filter_dir = _2_})}, summary = {open = "botright vsplit | vertical resize 50"}})
  local set_neotest_highlights
  local function _3_()
    local bg = "#666666"
    vim.api.nvim_set_hl(0, "NeotestDir", {bg = bg, fg = "#87CEEB"})
    vim.api.nvim_set_hl(0, "NeotestFile", {bg = bg, fg = "#ffffff"})
    vim.api.nvim_set_hl(0, "NeotestNamespace", {bg = bg, fg = "#90EE90"})
    vim.api.nvim_set_hl(0, "NeotestTest", {bg = bg, fg = "#ffffff"})
    vim.api.nvim_set_hl(0, "NeotestExpandMarker", {bg = bg, fg = "#333333"})
    vim.api.nvim_set_hl(0, "NeotestAdapterName", {bg = bg, fg = "#FFA500"})
    vim.api.nvim_set_hl(0, "NeotestIndent", {bg = bg, fg = "#333333"})
    vim.api.nvim_set_hl(0, "NeotestWinSelect", {bg = bg, fg = "#FFA500", bold = true})
    vim.api.nvim_set_hl(0, "NeotestMarked", {bg = bg, fg = "#FFD700"})
    return vim.api.nvim_set_hl(0, "NeotestTarget", {bg = bg, fg = "#FF6347"})
  end
  set_neotest_highlights = _3_
  set_neotest_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {callback = set_neotest_highlights})
  local function _4_()
    local bufname = vim.api.nvim_buf_get_name(0)
    if string.match(bufname, "Neotest Summary") then
      vim.api.nvim_set_option_value("winhighlight", "Normal:NeotestDir,NormalNC:NeotestDir,WinBar:NeotestDir,WinBarNC:NeotestDir", {scope = "local"})
      return vim.api.nvim_set_option_value("cursorline", false, {scope = "local"})
    else
      return nil
    end
  end
  return vim.api.nvim_create_autocmd("BufWinEnter", {pattern = "*", callback = _4_})
end
return {"nvim-neotest/neotest", dependencies = {"nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "nvim-treesitter/nvim-treesitter", "marilari88/neotest-vitest"}, config = _1_}
