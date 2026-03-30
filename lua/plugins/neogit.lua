-- [nfnl] fnl/plugins/neogit.fnl
local function _1_()
  local neogit = require("neogit")
  return neogit.setup({integrations = {telescope = true, diffview = true}, disable_hint = true, graph_style = "kitty", kind = "replace", sections = {recent = {folded = false, hidden = false}}, mappings = {status = {["<esc>"] = "Close"}, commit_editor = {["\226\130\172\226\130\172"] = "Submit"}, commit_editor_I = {["\226\130\172\226\130\172"] = "Submit"}}})
end
return {"NeogitOrg/neogit", cmd = "Neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim"}, config = _1_}
