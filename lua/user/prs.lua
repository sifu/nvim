-- [nfnl] fnl/user/prs.fnl
local M = {}
local repo_path = "/Users/sifu/prj/frontend-demo"
local function strip_ansi(s)
  local out, _ = string.gsub(s, "\27%[[%d;]*[mK]", "")
  return out
end
local win_id = nil
local function close()
  if (win_id and vim.api.nvim_win_is_valid(win_id)) then
    vim.api.nvim_win_close(win_id, true)
  else
  end
  win_id = nil
  return nil
end
local function current_line()
  return vim.api.nvim_buf_get_lines(0, (vim.api.nvim_win_get_cursor(0)[1] - 1), vim.api.nvim_win_get_cursor(0)[1], false)[1]
end
local function url_on_line(line)
  return string.match(line, "https?://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+")
end
local function branch_on_line(line)
  return string.match(line, "\226\142\135%s+(%S+)")
end
local function checkout_branch(branch)
  vim.notify(("Checking out " .. branch .. "\226\128\166"), vim.log.levels.INFO)
  local stderr_lines = {}
  local function _2_(_, data, _0)
    if data then
      for _1, l in ipairs(data) do
        if (l ~= "") then
          table.insert(stderr_lines, l)
        else
        end
      end
      return nil
    else
      return nil
    end
  end
  local function _5_(_, code, _0)
    if (code == 0) then
      close()
      return vim.notify(("Switched to " .. branch), vim.log.levels.INFO)
    else
      return vim.notify(("git checkout failed: " .. table.concat(stderr_lines, "\n")), vim.log.levels.ERROR)
    end
  end
  return vim.fn.jobstart({"git", "-C", repo_path, "checkout", branch}, {stderr_buffered = true, on_stderr = _2_, on_exit = _5_})
end
local function handle_enter()
  local line = current_line()
  local url = url_on_line(line)
  local branch = branch_on_line(line)
  if url then
    return vim.ui.open(url)
  elseif branch then
    return checkout_branch(branch)
  else
    return vim.notify("No URL or branch on this line", vim.log.levels.WARN)
  end
end
local function open_popup(lines)
  close()
  local buf = vim.api.nvim_create_buf(false, true)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.min(math.max(80, (ui.width - 20)), 140)
  local height = math.min(math.max(10, #lines), (ui.height - 6))
  local opts = {relative = "editor", width = width, height = height, row = math.floor(((ui.height - height) / 2)), col = math.floor(((ui.width - width) / 2)), style = "minimal", border = "rounded", title = " GitHub PRs ", title_pos = "center"}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.api.nvim_set_option_value("filetype", "prs", {buf = buf})
  win_id = vim.api.nvim_open_win(buf, true, opts)
  vim.keymap.set("n", "q", close, {buffer = buf, nowait = true, silent = true})
  vim.keymap.set("n", "<esc>", close, {buffer = buf, nowait = true, silent = true})
  return vim.keymap.set("n", "<cr>", handle_enter, {buffer = buf, nowait = true, silent = true})
end
M.show = function()
  local stdout_lines = {}
  local stderr_lines = {}
  vim.notify("Loading PRs\226\128\166", vim.log.levels.INFO)
  local function _8_(_, data, _0)
    if data then
      for _1, line in ipairs(data) do
        table.insert(stdout_lines, strip_ansi(line))
      end
      return nil
    else
      return nil
    end
  end
  local function _10_(_, data, _0)
    if data then
      for _1, line in ipairs(data) do
        if (line ~= "") then
          table.insert(stderr_lines, line)
        else
        end
      end
      return nil
    else
      return nil
    end
  end
  local function _13_(_, code, _0)
    while ((#stdout_lines > 0) and (stdout_lines[#stdout_lines] == "")) do
      table.remove(stdout_lines)
    end
    if (code == 0) then
      if (#stdout_lines > 0) then
        return open_popup(stdout_lines)
      else
        return vim.notify("prs: no output", vim.log.levels.WARN)
      end
    else
      return vim.notify(("prs failed (exit " .. code .. "): " .. table.concat(stderr_lines, "\n")), vim.log.levels.ERROR)
    end
  end
  return vim.fn.jobstart({"bb", "/s/bin/prs.clj"}, {stdout_buffered = true, stderr_buffered = true, on_stdout = _8_, on_stderr = _10_, on_exit = _13_})
end
return M
