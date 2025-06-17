-- [nfnl] fnl/user/follow-redirect.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local function follow_redirect()
  local line = vim.fn.getline(".")
  local col = (vim.fn.col(".") - 1)
  local url_pattern = "https?://[^ \9\n\r\"'<>]+"
  local urls = {}
  local pos = 0
  while pos do
    local start_idx, end_idx = string.find(line, url_pattern, (pos + 1))
    if start_idx then
      table.insert(urls, {start = (start_idx - 1), ["end"] = (end_idx - 1), url = string.sub(line, start_idx, end_idx)})
      pos = end_idx
    else
      pos = nil
    end
  end
  local target_url = nil
  for _, url_info in ipairs(urls) do
    if ((col >= url_info.start) and (col <= url_info["end"])) then
      target_url = url_info
    else
    end
  end
  if target_url then
    print(("Found URL: " .. target_url.url))
    local curl_cmd = ("curl -sL -o /dev/null -w '%{url_effective}' '" .. target_url.url .. "'")
    local result = vim.fn.system(curl_cmd)
    local final_url = vim.trim(result)
    if ((final_url ~= "") and (vim.v.shell_error == 0) and (final_url ~= target_url.url)) then
      vim.fn.setpos(".", {vim.fn.bufnr(), vim.fn.line("."), (target_url.start + 1), 0})
      vim.cmd("normal! v")
      vim.fn.setpos(".", {vim.fn.bufnr(), vim.fn.line("."), (target_url["end"] + 1), 0})
      vim.cmd(("normal! c" .. final_url))
      return print(("Replaced with: " .. final_url))
    else
      return print(("No redirect found. Final URL: " .. final_url))
    end
  else
    return print("No URL found at cursor position")
  end
end
return vim.api.nvim_create_user_command("FollowRedirect", follow_redirect, {desc = "Replace URL at cursor with its redirect destination"})
