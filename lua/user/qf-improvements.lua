-- [nfnl] fnl/user/qf-improvements.fnl
local function _1_()
  return pcall(vim.keymap.del, "n", "<enter>")
end
vim.api.nvim_create_autocmd("FileType", {pattern = "qf", callback = _1_})
local function remove_qf_item()
  local curqfidx = vim.fn.line(".")
  local qfall = vim.fn.getqflist()
  if (#qfall > 0) then
    table.remove(qfall, curqfidx)
    vim.fn.setqflist(qfall, "r")
    vim.cmd("copen")
    local new_idx
    if (curqfidx < #qfall) then
      new_idx = curqfidx
    else
      new_idx = math.max((curqfidx - 1), 1)
    end
    local winid = vim.fn.win_getid()
    return vim.api.nvim_win_set_cursor(winid, {new_idx, 0})
  else
    return nil
  end
end
vim.cmd("command! RemoveQFItem lua require('fennel').eval('(remove-qf-item)')")
local function _4_()
  return vim.keymap.set("n", "dd", remove_qf_item, {buffer = true, silent = true, noremap = true})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "qf", callback = _4_})
