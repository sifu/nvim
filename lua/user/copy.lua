-- [nfnl] fnl/user/copy.fnl
local function copy_and_notify(text)
  vim.cmd("silent! wa")
  vim.fn.setreg("+", text)
  vim.notify(("Copied: " .. text))
  return text
end
local function copy_filepath_with_line()
  local filepath = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local filepath_with_line = ("@" .. filepath .. " on line " .. line_number)
  return copy_and_notify(filepath_with_line)
end
local function copy_file_reference()
  local filepath = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local filepath_with_line = (filepath .. ":" .. line_number)
  return copy_and_notify(filepath_with_line)
end
local function copy_filepath_raw()
  return copy_and_notify(vim.fn.expand("%:p"))
end
local function copy_filepath()
  local filepath = vim.fn.expand("%")
  local prefixed = ("@" .. filepath)
  return copy_and_notify(prefixed)
end
local function copy_word_with_filepath()
  local word = vim.fn.expand("<cword>")
  local filepath = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local word_with_filepath = ("`" .. word .. "` (@" .. filepath .. " on line " .. line_number .. ")")
  return copy_and_notify(word_with_filepath)
end
local function open_prompt_buffer()
  local filepath = vim.fn.expand("%:.")
  local line_number = vim.fn.line(".")
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(80, (vim.o.columns - 4))
  local height = math.min(20, (vim.o.lines - 4))
  local row = math.floor(((vim.o.lines - height) / 2))
  local col = math.floor(((vim.o.columns - width) / 2))
  local win = vim.api.nvim_open_win(buf, true, {relative = "editor", width = width, height = height, row = row, col = col, style = "minimal", border = "rounded", title = " Prompt ", title_pos = "center"})
  local copy_and_close
  local function _1_()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n")
    vim.fn.setreg("+", text)
    vim.api.nvim_win_close(win, true)
    local current = tonumber(vim.fn.system("tmux display-message -p '#{window_index}'"))
    local windows = vim.fn.system("tmux list-windows -F '#{window_index} #{window_name}'")
    local indices = {}
    for idx in string.gmatch(windows, "(%d+) Claude[^\n]*") do
      table.insert(indices, tonumber(idx))
    end
    local target = nil
    for _, idx in ipairs(indices) do
      if ((idx > current) and (target == nil)) then
        target = idx
      else
      end
    end
    if (target == nil) then
      if (#indices > 0) then
        target = indices[1]
      else
      end
    else
    end
    if target then
      vim.fn.system(("tmux set-buffer -- " .. vim.fn.shellescape(text)))
      vim.fn.system(("tmux select-window -t " .. target))
      vim.fn.system("tmux paste-buffer")
      return vim.notify(("Pasted to Claude (window " .. target .. ")"))
    else
      return vim.notify("No Claude window found \226\128\148 copied to clipboard")
    end
  end
  copy_and_close = _1_
  local initial_text = ("@" .. filepath .. " on line " .. line_number)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {initial_text})
  vim.api.nvim_set_option_value("filetype", "markdown", {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.api.nvim_win_set_cursor(win, {1, (1 + #filepath)})
  vim.keymap.set({"n", "i"}, "<C-s>", copy_and_close, {buffer = buf})
  local function _6_()
    return vim.api.nvim_win_close(win, true)
  end
  return vim.keymap.set("n", "q", _6_, {buffer = buf})
end
local function show_in_popup(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(100, (vim.o.columns - 4))
  local height = math.min((#lines + 2), (vim.o.lines - 4))
  local row = math.floor(((vim.o.lines - height) / 2))
  local col = math.floor(((vim.o.columns - width) / 2))
  vim.api.nvim_open_win(buf, true, {relative = "editor", width = width, height = height, row = row, col = col, style = "minimal", border = "rounded", title = " i18n Translation ", title_pos = "center"})
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.keymap.set("n", "q", "<cmd>close<cr>", {buffer = buf})
  return vim.keymap.set("n", "<esc>", "<cmd>close<cr>", {buffer = buf})
end
local function find_i18n_key()
  vim.cmd("normal! yi'")
  local key = vim.fn.getreg("\"")
  if (key and (key ~= "")) then
    vim.fn.setreg("+", key)
    local output = vim.fn.system(("/Users/sifu/.claude/skills/find-i18n/find-i18n.sh " .. vim.fn.shellescape(key)))
    local lines = vim.split(output, "\n", {trimempty = true})
    return show_in_popup(lines)
  else
    return nil
  end
end
local function copy_filepath_with_line_range()
  local filepath = vim.fn.expand("%")
  local start_line = vim.fn.getpos("v")[2]
  local end_line = vim.fn.line(".")
  local sorted_start = math.min(start_line, end_line)
  local sorted_end = math.max(start_line, end_line)
  local filepath_with_range = ("@" .. filepath .. " line " .. sorted_start .. " to " .. sorted_end)
  return copy_and_notify(filepath_with_range)
end
return {["copy-and-notify"] = copy_and_notify, ["copy-filepath-with-line"] = copy_filepath_with_line, ["copy-file-reference"] = copy_file_reference, ["copy-filepath-raw"] = copy_filepath_raw, ["copy-filepath"] = copy_filepath, ["copy-word-with-filepath"] = copy_word_with_filepath, ["open-prompt-buffer"] = open_prompt_buffer, ["find-i18n-key"] = find_i18n_key, ["copy-filepath-with-line-range"] = copy_filepath_with_line_range}
