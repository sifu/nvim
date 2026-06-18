-- [nfnl] fnl/user/trello-card-info.fnl
local env_path = "/s/.claude/.trello.env"
local credentials = nil
local function read_credentials()
  if not credentials then
    local f = io.open(env_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local key = string.match(content, "TRELLO_KEY=%s*([^%s]+)")
      local token = string.match(content, "TRELLO_TOKEN=%s*([^%s]+)")
      if (key and token) then
        credentials = {key = key, token = token}
      else
      end
    else
    end
  else
  end
  return credentials
end
local function shortlink_on_line(line)
  local url = string.match(line, "%[Trello%]%((.-)%)")
  if url then
    return string.match(url, "trello%.com/c/(%w+)")
  else
    return nil
  end
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
local function open_popup(lines, line_urls)
  close()
  local buf = vim.api.nvim_create_buf(false, true)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.min(math.max(60, (ui.width - 20)), 100)
  local content_height
  do
    local h = 0
    for _, l in ipairs(lines) do
      h = (h + math.max(1, math.ceil((#l / width))))
    end
    content_height = h
  end
  local height = math.min(math.max(12, content_height), (ui.height - 6))
  local opts = {relative = "editor", width = width, height = height, row = math.floor(((ui.height - height) / 2)), col = math.floor(((ui.width - width) / 2)), style = "minimal", border = "rounded", title = " Trello ", title_pos = "center"}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, {buf = buf})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
  vim.api.nvim_set_option_value("filetype", "markdown", {buf = buf})
  win_id = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_set_option_value("wrap", true, {win = win_id})
  vim.api.nvim_set_option_value("linebreak", true, {win = win_id})
  vim.keymap.set("n", "q", close, {buffer = buf, nowait = true, silent = true})
  vim.keymap.set("n", "<esc>", close, {buffer = buf, nowait = true, silent = true})
  local function _6_()
    local row = vim.api.nvim_win_get_cursor(win_id)[1]
    local target = line_urls[row]
    if target then
      close()
      return vim.ui.open(target)
    else
      return vim.notify("No PR link on this line", vim.log.levels.INFO)
    end
  end
  vim.keymap.set("n", "<cr>", _6_, {buffer = buf, nowait = true, silent = true})
  return vim.api.nvim_create_autocmd("BufLeave", {buffer = buf, once = true, callback = close})
end
local function github_prs(card)
  local tbl_26_ = {}
  local i_27_ = 0
  for _, a in ipairs((card.attachments or {})) do
    local val_28_
    if (a.url and string.match(a.url, "github%.com/.+/pull/%d+")) then
      local _8_
      if (a.name and (a.name ~= "")) then
        _8_ = a.name
      else
        _8_ = a.url
      end
      val_28_ = {name = _8_, url = a.url}
    else
      val_28_ = nil
    end
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  return tbl_26_
end
local function card__3elines(card)
  local list_name
  local _13_
  do
    local t_12_ = card
    if (nil ~= t_12_) then
      t_12_ = t_12_.list
    else
    end
    if (nil ~= t_12_) then
      t_12_ = t_12_.name
    else
    end
    _13_ = t_12_
  end
  list_name = (_13_ or "(no list)")
  local members
  do
    local tbl_26_ = {}
    local i_27_ = 0
    for _, m in ipairs((card.members or {})) do
      local val_28_ = m.fullName
      if (nil ~= val_28_) then
        i_27_ = (i_27_ + 1)
        tbl_26_[i_27_] = val_28_
      else
      end
    end
    members = tbl_26_
  end
  local prs = github_prs(card)
  local lines = {list_name, string.rep("\226\148\128", math.max(12, #list_name)), (card.name or "(untitled)"), ""}
  local line_urls = {}
  local _17_
  if (#members > 0) then
    _17_ = table.concat(members, ", ")
  else
    _17_ = "\226\128\148"
  end
  table.insert(lines, ("Members: " .. _17_))
  if (#prs > 0) then
    table.insert(lines, "")
    for _, pr in ipairs(prs) do
      table.insert(lines, (" " .. pr.name .. " (<CR> to open)"))
      line_urls[#lines] = pr.url
    end
  else
  end
  if (card.desc and (card.desc ~= "")) then
    table.insert(lines, "")
    for line in string.gmatch((card.desc .. "\n"), "(.-)\n") do
      table.insert(lines, line)
    end
  else
  end
  return lines, line_urls
end
local function fetch_and_show(shortlink, creds)
  local url = ("https://api.trello.com/1/cards/" .. shortlink .. "?fields=name,desc&list=true" .. "&members=true&member_fields=fullName" .. "&attachments=true&attachment_fields=name,url" .. "&key=" .. creds.key .. "&token=" .. creds.token)
  local chunks = {}
  vim.notify("Trello: fetching card\226\128\166", vim.log.levels.INFO)
  local function _21_(_, data, _0)
    if data then
      for _1, d in ipairs(data) do
        table.insert(chunks, d)
      end
      return nil
    else
      return nil
    end
  end
  local function _23_(_, code, _0)
    local function _24_()
      if (code ~= 0) then
        return vim.notify(("Trello: curl failed (exit " .. code .. ")"), vim.log.levels.ERROR)
      else
        local body = table.concat(chunks, "\n")
        local ok, card = pcall(vim.json.decode, body)
        if (ok and (type(card) == "table") and card.name) then
          return open_popup(card__3elines(card))
        else
          return vim.notify(("Trello: " .. body), vim.log.levels.WARN)
        end
      end
    end
    return vim.schedule(_24_)
  end
  return vim.fn.jobstart({"curl", "-s", url}, {stdout_buffered = true, on_stdout = _21_, on_exit = _23_})
end
local function show_card_info()
  local line = vim.api.nvim_get_current_line()
  local shortlink = shortlink_on_line(line)
  if not shortlink then
    return vim.notify("No [Trello](\226\128\166) link on this line", vim.log.levels.WARN)
  else
    local creds = read_credentials()
    if not creds then
      return vim.notify(("Trello: missing credentials in " .. env_path), vim.log.levels.ERROR)
    else
      return fetch_and_show(shortlink, creds)
    end
  end
end
local function _29_()
  return vim.keymap.set("n", ",ct", show_card_info, {buffer = true, silent = true, desc = "Trello card info"})
end
vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _29_})
return {["show-card-info"] = show_card_info}
