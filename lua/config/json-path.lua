-- [nfnl] fnl/config/json-path.fnl
local ns = vim.api.nvim_create_namespace("json-path")
local function get_json_path(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "json")
  if not ok then
    return nil
  else
  end
  parser:parse()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = (cursor[1] - 1)
  local line = vim.api.nvim_buf_get_lines(buf, row, (row + 1), false)[1]
  local first_nonblank
  if line then
    first_nonblank = line:find("[^%s]")
  else
    first_nonblank = nil
  end
  local col
  if first_nonblank then
    col = (first_nonblank - 1)
  else
    col = cursor[2]
  end
  local node = vim.treesitter.get_node({bufnr = buf, pos = {row, col}})
  if (node == nil) then
    return nil
  else
  end
  local parts = {}
  local current = node
  while (current ~= nil) do
    do
      local node_type = current:type()
      if (node_type == "pair") then
        local key_node = current:named_child(0)
        if (key_node ~= nil) then
          local key_text = vim.treesitter.get_node_text(key_node, buf)
          local clean = key_text:match("^\"(.-)\"$")
          table.insert(parts, 1, (clean or key_text))
        else
        end
      else
      end
      if (node_type == "array") then
        local idx = 0
        do
          local child_count = current:named_child_count()
          for i = 0, (child_count - 1) do
            local child = current:named_child(i)
            local sr, sc, er, ec = child:range()
            local nr, nc = node:start()
            if ((nr < sr) or ((nr == sr) and (nc < sc))) then
              break
            else
            end
            idx = i
          end
        end
        table.insert(parts, 1, ("[" .. idx .. "]"))
      else
      end
    end
    current = current:parent()
  end
  if (#parts == 0) then
    return nil
  else
  end
  local raw = table.concat(parts, ".")
  return raw:gsub("%.%[", "[")
end
do
  local group = vim.api.nvim_create_augroup("json-path", {clear = true})
  local function _10_()
    do
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      if (vim.bo.filetype == "json") then
        local ok, path = pcall(get_json_path, buf)
        if (ok and path) then
          local row = (vim.fn.line(".") - 1)
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {virt_text = {{path, "Comment"}}, virt_text_pos = "eol"})
        else
        end
      else
      end
    end
    return nil
  end
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {group = group, callback = _10_})
end
return {["get-json-path"] = get_json_path}
