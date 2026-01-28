-- [nfnl] fnl/plugins/neogit.fnl
local function _1_()
  vim.keymap.set("n", "\226\130\172\226\130\172", ":w<cr>:bdelete<cr>", {buffer = true, silent = true})
  return vim.keymap.set("i", "\226\130\172\226\130\172", "<esc>:w<cr>:bdelete<cr>", {buffer = true, silent = true})
end
vim.api.nvim_create_autocmd({"BufNew", "BufEnter", "BufWinEnter"}, {pattern = "*COMMIT_EDITMSG", callback = _1_})
local function _2_()
  local neogit = require("neogit")
  return neogit.setup({integrations = {telescope = true, diffview = true}, disable_hint = true, graph_style = "kitty", kind = "replace", sections = {recent = {folded = false, hidden = false}}, mappings = {status = {["<esc>"] = "Close"}}})
end
return {"NeogitOrg/neogit", cmd = "Neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim"}, config = _2_}
