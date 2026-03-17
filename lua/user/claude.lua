-- [nfnl] fnl/user/claude.fnl
local claude_bin
do
  local path = vim.fn.exepath("claude")
  if (path ~= "") then
    claude_bin = path
  else
    local home = vim.fn.expand("$HOME")
    local local_bin = (home .. "/.local/bin/claude")
    if (vim.fn.executable(local_bin) == 1) then
      claude_bin = local_bin
    else
      claude_bin = "claude"
    end
  end
end
local function show_thinking()
  local buf = vim.api.nvim_create_buf(false, true)
  local text = " Claude is thinking... "
  local width = #text
  local cols = vim.o.columns
  local opts = {relative = "editor", width = width, height = 1, col = (math.floor((cols / 2)) - math.floor((width / 2))), row = 1, style = "minimal", border = "rounded", zindex = 50}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {text})
  return vim.api.nvim_open_win(buf, false, opts)
end
local function hide_thinking(win)
  if (win and vim.api.nvim_win_is_valid(win)) then
    return vim.api.nvim_win_close(win, true)
  else
    return nil
  end
end
local function show_in_split(text)
  vim.cmd("botright new")
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.split(text, "\n")
  vim.api.nvim_set_option_value("buftype", "nofile", {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.api.nvim_set_option_value("swapfile", false, {buf = buf})
  vim.api.nvim_set_option_value("filetype", "markdown", {buf = buf})
  vim.api.nvim_buf_set_name(buf, "Claude")
  return vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end
local function replace_lines(buf, start_line, end_line, text)
  local lines = vim.split(text, "\n")
  local n = #lines
  if ((n > 0) and (lines[n] == "")) then
    table.remove(lines)
  else
  end
  return vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end
local function handle_result(result, mode, buf, start_line, end_line, win)
  hide_thinking(win)
  if (result.code == 0) then
    if (mode == "replace") then
      replace_lines(buf, start_line, end_line, result.stdout)
    else
      show_in_split(result.stdout)
    end
    return vim.notify("Claude done", vim.log.levels.INFO)
  else
    return vim.notify(("Claude failed: " .. (result.stderr or tostring(result.code))), vim.log.levels.ERROR)
  end
end
local function run_claude_range(line1, line2, prompt, mode)
  local start_line = (math.min(line1, line2) - 1)
  local end_line = math.max(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  local text = table.concat(lines, "\n")
  local buf = vim.api.nvim_get_current_buf()
  local full_prompt = (prompt .. "\n\n" .. text)
  local win = show_thinking()
  local function _7_(result)
    return handle_result(result, mode, buf, start_line, end_line, win)
  end
  return vim.system({claude_bin, "-p", full_prompt, "--output-format", "text"}, {}, vim.schedule_wrap(_7_))
end
local function register_commands()
  do
    local commands = {ClaudeGrammar = {prompt = "Fix grammar and spelling. Return ONLY the corrected text, nothing else.", mode = "replace"}, ClaudeDocstring = {prompt = "Add documentation comments to this code. Return ONLY the documented code, no explanations or markdown fences.", mode = "replace"}, ClaudeTests = {prompt = "Write unit tests for this code. Return ONLY the test code, no explanations or markdown fences.", mode = "replace"}, ClaudeOptimize = {prompt = "Optimize this code. Return ONLY the optimized code, no explanations or markdown fences.", mode = "replace"}, ClaudeFixBugs = {prompt = "Fix any bugs in this code. Return ONLY the fixed code, no explanations or markdown fences.", mode = "replace"}, ClaudeExplain = {prompt = "Explain what this code does in detail.", mode = "display"}, ClaudeSummarize = {prompt = "Summarize this text concisely.", mode = "display"}, ClaudeReadability = {prompt = "Analyze the readability of this code and suggest improvements.", mode = "display"}}
    for name, opts in pairs(commands) do
      local function _8_(args)
        return run_claude_range(args.line1, args.line2, opts.prompt, opts.mode)
      end
      vim.api.nvim_create_user_command(name, _8_, {range = true})
    end
  end
  local function _9_(args)
    local start_line = (math.min(args.line1, args.line2) - 1)
    local end_line = math.max(args.line1, args.line2)
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
    local text = table.concat(lines, "\n")
    local buf = vim.api.nvim_get_current_buf()
    local function _10_(instruction)
      if (instruction and (instruction ~= "")) then
        local full_prompt = ("Apply this edit instruction to the code below. Return ONLY the modified code, no explanations or markdown fences.\n\nInstruction: " .. instruction .. "\n\nCode:\n" .. text)
        local win = show_thinking()
        local function _11_(result)
          return handle_result(result, "replace", buf, start_line, end_line, win)
        end
        return vim.system({claude_bin, "-p", full_prompt, "--output-format", "text"}, {}, vim.schedule_wrap(_11_))
      else
        return nil
      end
    end
    return vim.ui.input({prompt = "Edit instruction: "}, _10_)
  end
  vim.api.nvim_create_user_command("ClaudeEdit", _9_, {range = true})
  local function _13_(args)
    local function _14_(language)
      if (language and (language ~= "")) then
        return run_claude_range(args.line1, args.line2, ("Translate this text to " .. language .. ". Return ONLY the translated text, nothing else."), "replace")
      else
        return nil
      end
    end
    return vim.ui.input({prompt = "Translate to: "}, _14_)
  end
  return vim.api.nvim_create_user_command("ClaudeTranslate", _13_, {range = true})
end
local function chat()
  vim.cmd("botright split")
  vim.cmd("terminal claude")
  return vim.cmd("startinsert")
end
register_commands()
return {chat = chat}
