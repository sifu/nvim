-- [nfnl] fnl/user/hunk-nav.fnl
local hunks_title = "Git hunks"
local function tag_list()
  return vim.fn.setqflist({}, "a", {title = hunks_title})
end
local function hunks_list_current_3f()
  local info = vim.fn.getqflist({title = true, size = true})
  return ((info.title == hunks_title) and (info.size > 0))
end
local function populate(open_3f)
  local gitsigns = require("gitsigns")
  return gitsigns.setqflist("all", {open = open_3f}, tag_list)
end
local function populate_all_hunks()
  return populate(true)
end
local function preview_after_attach()
  local function _1_()
    return pcall(require("gitsigns").preview_hunk)
  end
  return vim.schedule(_1_)
end
local function jump_and_preview(cmd)
  local ok, _ = pcall(cmd)
  if ok then
    return preview_after_attach()
  else
    return nil
  end
end
local function navigate(direction)
  local cmd
  if (direction == "next") then
    cmd = vim.cmd.cnext
  else
    cmd = vim.cmd.cprev
  end
  if hunks_list_current_3f() then
    return jump_and_preview(cmd)
  else
    local gitsigns = require("gitsigns")
    local function _4_()
      tag_list()
      return jump_and_preview(cmd)
    end
    return gitsigns.setqflist("all", {open = false}, _4_)
  end
end
local function next_hunk_global()
  return navigate("next")
end
local function prev_hunk_global()
  return navigate("prev")
end
return {populate_all_hunks = populate_all_hunks, next_hunk_global = next_hunk_global, prev_hunk_global = prev_hunk_global}
