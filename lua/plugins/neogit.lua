-- [nfnl] fnl/plugins/neogit.fnl
local function toggle_file_fold()
  local status = require("neogit.buffers.status")
  local instance = status.instance()
  if (instance and instance.buffer and instance.buffer.ui) then
    local fold = instance.buffer.ui:get_fold_under_cursor()
    if fold then
      local target = fold
      local found_item = false
      local node = target
      while node do
        if (node.options and (node.options.tag == "Item")) then
          target = node
          found_item = true
        else
        end
        node = node.parent
      end
      if not found_item then
        target = fold
      else
      end
      if target.options.on_open then
        return target.options.on_open(target, instance.buffer.ui)
      else
        local start, _ = target:row_range_abs()
        instance.buffer:move_cursor(start)
        local ok, _0 = pcall(vim.cmd, "normal! za")
        if ok then
          target.options.folded = not target.options.folded
          return nil
        else
          return nil
        end
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function _7_()
  local neogit = require("neogit")
  return neogit.setup({integrations = {telescope = true, diffview = true}, disable_hint = true, graph_style = "kitty", kind = "replace", sections = {recent = {folded = false, hidden = false}}, mappings = {status = {["<esc>"] = "Close", ["<tab>"] = toggle_file_fold, za = toggle_file_fold}, commit_editor = {["\226\130\172\226\130\172"] = "Submit"}, commit_editor_I = {["\226\130\172\226\130\172"] = "Submit"}}})
end
return {"NeogitOrg/neogit", cmd = "Neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim"}, config = _7_}
