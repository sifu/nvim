-- [nfnl] fnl/config/shared-yank.fnl
local shared_yank_file = (vim.fn.stdpath("data") .. "/shared-yank")
local last_written = nil
local function write_yank()
  local event = vim.v.event
  if (event.operator == "y") then
    local regtype = event.regtype
    local regcontents = table.concat(event.regcontents, "\n")
    local data = (regtype .. "\n" .. regcontents)
    last_written = data
    local f = io.open(shared_yank_file, "w")
    if f then
      f:write(data)
      return f:close()
    else
      return nil
    end
  else
    return nil
  end
end
local function read_yank()
  local f = io.open(shared_yank_file, "r")
  if f then
    local data = f:read("*a")
    f:close()
    if ((data ~= "") and (data ~= last_written)) then
      last_written = data
      local newline_pos = string.find(data, "\n")
      if newline_pos then
        local regtype = string.sub(data, 1, (newline_pos - 1))
        local contents = string.sub(data, (newline_pos + 1))
        return vim.fn.setreg("\"", contents, regtype)
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("TextYankPost", {callback = write_yank, desc = "Save yank to shared file"})
vim.api.nvim_create_autocmd("FocusGained", {callback = read_yank, desc = "Read shared yank on focus"})
return {}
