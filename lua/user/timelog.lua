-- [nfnl] Compiled from fnl/user/timelog.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local hourly_rate = 75
local timestamp_regex = "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d"
local log_statement_regex = "^%[.*%](%s*.*)$"
local function now()
  return os.date("%Y-%m-%d %H:%M")
end
local function date_string__3etime(date_string)
  local year, month, day, hour, min = string.match(date_string, "(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d)")
  return os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min)})
end
local function diff_time_in_seconds(_2_)
  local start = _2_[1]
  local _end = _2_[2]
  local _3_
  if _end then
    _3_ = date_string__3etime(_end)
  else
    _3_ = os.time()
  end
  return os.difftime(_3_, date_string__3etime(start))
end
local function is_timelog_line_3f(line)
  return (nil ~= string.find(line, "^%[[%d%-%s:]*%]"))
end
local function get_timestamps(line)
  return str.split(string.match(line, "^%[(.*)%]"), "%s%-%s")
end
local function line__3eduration(line)
  return diff_time_in_seconds(get_timestamps(line))
end
local function calculate_cost(duration)
  local hours = (duration / 3600)
  return (hours * hourly_rate)
end
local function format_duration(duration)
  local minutes = math.floor((duration / 60))
  local hours = math.floor((minutes / 60))
  local days = math.floor((hours / 24))
  local remaining_minutes = (minutes % 60)
  local parts = {}
  local cost = calculate_cost(duration)
  local _
  if (hours > 0) then
    _ = table.insert(parts, (hours .. "h"))
  else
    _ = nil
  end
  local _0
  if (remaining_minutes > 0) then
    _0 = table.insert(parts, (remaining_minutes .. "m"))
  else
    _0 = nil
  end
  if core["empty?"](parts) then
    return " 0m (0\226\130\172)"
  else
    return (" " .. table.concat(parts, " ") .. " (" .. string.format("%.2f", cost) .. "\226\130\172)")
  end
end
local function is_running_3f(line)
  return (1 == #get_timestamps(line))
end
local function get_timelog_lines(lines)
  local result = {}
  for _, line in ipairs(lines) do
    if is_timelog_line_3f(line) then
      table.insert(result, line)
    else
    end
  end
  return result
end
local function stop_task(line)
  local timestamp = string.match(line, timestamp_regex)
  local log_statement = string.match(line, log_statement_regex)
  return ("[" .. timestamp .. " - " .. now() .. "]" .. log_statement)
end
local timetracking_ns = vim.api.nvim_create_namespace("timetracking_virtual_text")
local current_extmark_id = nil
local function clear_virtual_text()
  if current_extmark_id then
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_del_extmark(buf, timetracking_ns, current_extmark_id)
    current_extmark_id = nil
    return nil
  else
    return nil
  end
end
local function show_virtual_text(text)
  clear_virtual_text()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local opts = {virt_text = {{text, "Comment"}}, virt_text_pos = "right_align"}
  current_extmark_id = vim.api.nvim_buf_set_extmark(buf, timetracking_ns, (line - 1), 0, opts)
  return nil
end
local function _10_()
  return clear_virtual_text()
end
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {callback = _10_, group = vim.api.nvim_create_augroup("TimetrackingVirtualText", {clear = true})})
local function check_current_line()
  clear_virtual_text()
  local buf = vim.api.nvim_get_current_buf()
  local _let_11_ = vim.api.nvim_win_get_cursor(0)
  local row = _let_11_[1]
  local current_line = vim.api.nvim_buf_get_lines(buf, (row - 1), row, false)[1]
  if is_timelog_line_3f(current_line) then
    return show_virtual_text(format_duration(line__3eduration(current_line)))
  else
    return nil
  end
end
local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = (start_pos[2] - 1)
  local end_line = end_pos[2]
  local buf = vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
end
local function sum_durations(lines)
  local total = 0
  for _, line in ipairs(get_timelog_lines(lines)) do
    total = (total + line__3eduration(line))
  end
  return total
end
local popup_win_id = nil
local function close_popup()
  if popup_win_id then
    if vim.api.nvim_win_is_valid(popup_win_id) then
      vim.api.nvim_win_close(popup_win_id, true)
    else
    end
    popup_win_id = nil
    return nil
  else
    return nil
  end
end
vim.api.nvim_set_hl(0, "TimelogPopup", {bg = "White", fg = "Black"})
local function show_popup(text)
  close_popup()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = (#text + 4)
  local height = 1
  local opts = {relative = "cursor", width = width, height = height, row = -1, col = 5, style = "minimal", border = "rounded", noautocmd = true, focusable = false}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {text})
  popup_win_id = vim.api.nvim_open_win(buf, false, opts)
  vim.api.nvim_win_set_option(popup_win_id, "winhl", "Normal:TimelogPopup")
  local function _15_()
    return close_popup()
  end
  return vim.defer_fn(_15_, 4000)
end
local function sum_selected_durations()
  local lines = get_visual_selection()
  local total = sum_durations(lines)
  return show_popup(("Total: " .. format_duration(total)))
end
local function close_running_task()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local running_line_idx = nil
  for idx, line in ipairs(lines) do
    if (is_timelog_line_3f(line) and is_running_3f(line)) then
      running_line_idx = (idx - 1)
    else
    end
  end
  if running_line_idx then
    local running_line = lines[(running_line_idx + 1)]
    local stopped_line = stop_task(running_line)
    vim.api.nvim_buf_set_lines(buf, running_line_idx, (running_line_idx + 1), false, {stopped_line})
    return vim.cmd("write")
  else
    return nil
  end
end
local function get_message_from_line(line)
  return string.match(line, log_statement_regex)
end
local function create_new_task(message)
  return ("[" .. now() .. "]" .. message)
end
local function append_new_task_with_current_message()
  local buf = vim.api.nvim_get_current_buf()
  local _let_18_ = vim.api.nvim_win_get_cursor(0)
  local row = _let_18_[1]
  local current_line = vim.api.nvim_buf_get_lines(buf, (row - 1), row, false)[1]
  if is_timelog_line_3f(current_line) then
    close_running_task()
    local message = get_message_from_line(current_line)
    local new_line = create_new_task(message)
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {new_line})
    vim.cmd("norm! G")
    return vim.cmd("write")
  else
    return nil
  end
end
local function append_new_task()
  local buf = vim.api.nvim_get_current_buf()
  local _let_20_ = vim.api.nvim_win_get_cursor(0)
  local row = _let_20_[1]
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if core["empty?"](lines) then
    local new_line = create_new_task(" ")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {new_line})
  else
    local current_line = vim.api.nvim_buf_get_lines(buf, (row - 1), row, false)[1]
    if is_timelog_line_3f(current_line) then
      close_running_task()
    else
    end
  end
  local new_line = create_new_task(" ")
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {new_line})
  vim.cmd("norm! G")
  return vim.cmd("write")
end
vim.filetype.add({extension = {timelog = "timelog"}})
local function _23_()
  return check_current_line()
end
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {callback = _23_, group = vim.api.nvim_create_augroup("TimetrackingVirtualText", {clear = true})})
local function no_op()
end
local function _24_()
  vim.keymap.set("n", "<leader>d", no_op, {buffer = true})
  vim.keymap.set("n", "\226\130\172tb", append_new_task, {buffer = true, desc = "Start a new task"})
  vim.keymap.set("n", "\226\130\172te", close_running_task, {buffer = true, desc = "Stop the current task"})
  vim.keymap.set("n", "<cr>", append_new_task_with_current_message, {buffer = true, desc = "Switch to this task"})
  return vim.keymap.set("x", "\226\130\172ts", sum_selected_durations, {buffer = true, desc = "Sum selected time entries"})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "timelog", callback = _24_})
