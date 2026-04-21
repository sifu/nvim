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
local timeout_ms = 120000
local current_cancel = nil
local function open_display_split()
  vim.cmd("botright new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.api.nvim_set_option_value("swapfile", false, {buf = buf})
  vim.api.nvim_set_option_value("filetype", "markdown", {buf = buf})
  vim.api.nvim_buf_set_name(buf, "Claude")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Claude is thinking..."})
  return buf
end
local function set_buf_from_text(buf, text)
  if vim.api.nvim_buf_is_valid(buf) then
    return vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  else
    return nil
  end
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
local function set_busy(buf, delta)
  if vim.api.nvim_buf_is_valid(buf) then
    local function _5_()
      local opts = vim.bo[buf]
      local cur = (opts.busy or 0)
      local next_val = math.max(0, (cur + delta))
      opts["busy"] = next_val
      return nil
    end
    pcall(_5_)
    return pcall(vim.api.nvim_exec_autocmds, "User", {pattern = "ClaudeBusyChanged"})
  else
    return nil
  end
end
local function parse_stream_line(line)
  if (not line or (line == "")) then
    return nil, nil
  else
    local ok, evt = pcall(vim.json.decode, line)
    if not (ok and (type(evt) == "table")) then
      return nil, nil
    else
      if ((evt.type == "stream_event") and evt.event and (evt.event.type == "content_block_delta") and evt.event.delta and (evt.event.delta.type == "text_delta")) then
        return evt.event.delta.text, nil
      elseif ((evt.type == "result") and evt.is_error) then
        return nil, (evt.result or ("CLI error (subtype=" .. tostring(evt.subtype) .. ")"))
      else
        return nil, nil
      end
    end
  end
end
local function run_claude_stream(system_prompt, user_prompt, callbacks)
  local cmd = {claude_bin, "-p", "--output-format", "stream-json", "--verbose", "--include-partial-messages"}
  local stdin_text
  if (system_prompt and (system_prompt ~= "")) then
    stdin_text = (system_prompt .. "\n\n" .. (user_prompt or ""))
  else
    stdin_text = (user_prompt or "")
  end
  local sbuf = ""
  local errbuf = ""
  local settled = false
  local proc = nil
  local timer = nil
  local function settle(kind, arg)
    if not settled then
      settled = true
      if timer then
        local t = timer
        local function _11_()
          t:stop()
          return t:close()
        end
        pcall(_11_)
        timer = nil
      else
      end
      local function _13_()
        if (kind == "done") then
          if callbacks["on-done"] then
            return callbacks["on-done"]()
          else
            return nil
          end
        else
          if callbacks["on-error"] then
            return callbacks["on-error"](arg)
          else
            return nil
          end
        end
      end
      return vim.schedule(_13_)
    else
      return nil
    end
  end
  local function on_chunk(_, chunk)
    if (chunk and not settled) then
      sbuf = (sbuf .. chunk)
      local keep_going = true
      while keep_going do
        local nl = string.find(sbuf, "\n", 1, true)
        if nl then
          local line = string.sub(sbuf, 1, (nl - 1))
          local text, err = parse_stream_line(line)
          sbuf = string.sub(sbuf, (nl + 1))
          if err then
            settle("error", err)
            keep_going = false
          else
            if (text and (text ~= "")) then
              local function _18_()
                if (not settled and callbacks["on-text"]) then
                  return callbacks["on-text"](text)
                else
                  return nil
                end
              end
              vim.schedule(_18_)
            else
            end
          end
        else
          keep_going = false
        end
      end
      return nil
    else
      return nil
    end
  end
  local function on_stderr(_, chunk)
    if (chunk and (chunk ~= "")) then
      errbuf = (errbuf .. chunk)
      return nil
    else
      return nil
    end
  end
  local function _25_(result)
    if (result.code and (result.code ~= 0)) then
      local msg
      if (errbuf and (errbuf ~= "")) then
        msg = string.sub(errbuf, 1, 800)
      else
        msg = (result.stderr or "<no stderr>")
      end
      return settle("error", string.format("claude exited %d: %s", result.code, msg))
    else
      return settle("done")
    end
  end
  proc = vim.system(cmd, {text = true, stdin = stdin_text, stdout = on_chunk, stderr = on_stderr, env = {TMUX = ""}}, _25_)
  if not settled then
    timer = vim.uv.new_timer()
    local function _28_()
      if not settled then
        if proc then
          local p = proc
          local function _29_()
            return p:kill(15)
          end
          pcall(_29_)
        else
        end
        return settle("error", ("claude timed out after " .. tostring(timeout_ms) .. "ms"))
      else
        return nil
      end
    end
    timer:start(timeout_ms, 0, vim.schedule_wrap(_28_))
  else
  end
  local function _33_()
    if not settled then
      if proc then
        local p = proc
        local function _34_()
          return p:kill(15)
        end
        pcall(_34_)
      else
      end
      return settle("error", "cancelled")
    else
      return nil
    end
  end
  return _33_
end
local function can_start()
  if current_cancel then
    vim.notify("Claude job already running; :ClaudeCancel to stop it", vim.log.levels.WARN)
    return false
  else
    return true
  end
end
local function run_replace(system_prompt, user_prompt, buf, start_line, end_line)
  local state = {acc = ""}
  set_busy(buf, 1)
  local function _38_(chunk)
    state.acc = (state.acc .. chunk)
    return nil
  end
  local function _39_()
    current_cancel = nil
    set_busy(buf, -1)
    if vim.api.nvim_buf_is_valid(buf) then
      replace_lines(buf, start_line, end_line, state.acc)
    else
    end
    return vim.notify("Claude done", vim.log.levels.INFO)
  end
  local function _41_(msg)
    current_cancel = nil
    set_busy(buf, -1)
    return vim.notify(("Claude failed: " .. msg), vim.log.levels.ERROR)
  end
  current_cancel = run_claude_stream(system_prompt, user_prompt, {["on-text"] = _38_, ["on-done"] = _39_, ["on-error"] = _41_})
  return nil
end
local function run_display(system_prompt, user_prompt)
  local split_buf = open_display_split()
  local state = {acc = "", started = false}
  local function _42_(chunk)
    if not state.started then
      state.started = true
      state.acc = ""
    else
    end
    state.acc = (state.acc .. chunk)
    return set_buf_from_text(split_buf, state.acc)
  end
  local function _44_()
    current_cancel = nil
    return vim.notify("Claude done", vim.log.levels.INFO)
  end
  local function _45_(msg)
    current_cancel = nil
    if vim.api.nvim_buf_is_valid(split_buf) then
      state.acc = (state.acc .. "\n\n[error: " .. msg .. "]")
      set_buf_from_text(split_buf, state.acc)
    else
    end
    return vim.notify(("Claude failed: " .. msg), vim.log.levels.ERROR)
  end
  current_cancel = run_claude_stream(system_prompt, user_prompt, {["on-text"] = _42_, ["on-done"] = _44_, ["on-error"] = _45_})
  return nil
end
local function range_slice(line1, line2)
  local start_line = (math.min(line1, line2) - 1)
  local end_line = math.max(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  return start_line, end_line, table.concat(lines, "\n")
end
local function register_commands()
  do
    local replace_cmds = {ClaudeGrammar = "Fix grammar and spelling. Return ONLY the corrected text, nothing else.", ClaudeDocstring = "Add documentation comments to this code. Return ONLY the documented code, no explanations or markdown fences.", ClaudeTests = "Write unit tests for this code. Return ONLY the test code, no explanations or markdown fences.", ClaudeOptimize = "Optimize this code. Return ONLY the optimized code, no explanations or markdown fences.", ClaudeFixBugs = "Fix any bugs in this code. Return ONLY the fixed code, no explanations or markdown fences."}
    local display_cmds = {ClaudeExplain = "Explain what this code does in detail.", ClaudeSummarize = "Summarize this text concisely.", ClaudeReadability = "Analyze the readability of this code and suggest improvements."}
    for name, system_prompt in pairs(replace_cmds) do
      local function _47_(args)
        if can_start() then
          local start_line, end_line, text = range_slice(args.line1, args.line2)
          local buf = vim.api.nvim_get_current_buf()
          return run_replace(system_prompt, text, buf, start_line, end_line)
        else
          return nil
        end
      end
      vim.api.nvim_create_user_command(name, _47_, {range = true})
    end
    for name, system_prompt in pairs(display_cmds) do
      local function _49_(args)
        if can_start() then
          local _, _0, text = range_slice(args.line1, args.line2)
          return run_display(system_prompt, text)
        else
          return nil
        end
      end
      vim.api.nvim_create_user_command(name, _49_, {range = true})
    end
  end
  local function _51_(args)
    if can_start() then
      local start_line, end_line, text = range_slice(args.line1, args.line2)
      local buf = vim.api.nvim_get_current_buf()
      local function _52_(instruction)
        if (instruction and (instruction ~= "")) then
          local system_prompt = "Apply the user's edit instruction to the code. Return ONLY the modified code, no explanations or markdown fences."
          local user_prompt = ("Instruction: " .. instruction .. "\n\nCode:\n" .. text)
          return run_replace(system_prompt, user_prompt, buf, start_line, end_line)
        else
          return nil
        end
      end
      return vim.ui.input({prompt = "Edit instruction: "}, _52_)
    else
      return nil
    end
  end
  vim.api.nvim_create_user_command("ClaudeEdit", _51_, {range = true})
  local function _55_(args)
    if can_start() then
      local start_line, end_line, text = range_slice(args.line1, args.line2)
      local buf = vim.api.nvim_get_current_buf()
      local function _56_(language)
        if (language and (language ~= "")) then
          local system_prompt = ("Translate the user's text to " .. language .. ". Return ONLY the translated text, nothing else.")
          return run_replace(system_prompt, text, buf, start_line, end_line)
        else
          return nil
        end
      end
      return vim.ui.input({prompt = "Translate to: "}, _56_)
    else
      return nil
    end
  end
  vim.api.nvim_create_user_command("ClaudeTranslate", _55_, {range = true})
  local function _59_()
    if current_cancel then
      local c = current_cancel
      current_cancel = nil
      return c()
    else
      return vim.notify("no Claude job running", vim.log.levels.INFO)
    end
  end
  return vim.api.nvim_create_user_command("ClaudeCancel", _59_, {})
end
local function chat()
  vim.cmd("botright split")
  vim.cmd("terminal claude")
  return vim.cmd("startinsert")
end
register_commands()
return {chat = chat}
