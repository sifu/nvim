-- [nfnl] Compiled from fnl/user/html-to-jsx.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local str = autoload("nfnl.string")
local function kebab__3ecamel(s)
  local function _2_(word)
    local first = string.sub(word, 2, 2)
    local rest = string.sub(word, 3)
    return (string.upper(first) .. rest)
  end
  return string.gsub(s, "-%a+", _2_)
end
local function class__3eclassName(s)
  return string.gsub(s, "class=", "className=")
end
local function remove_comments(s)
  return string.gsub(s, "<!%-%- .* %-%->", "")
end
local function html__3ejsx(html)
  return remove_comments(kebab__3ecamel(class__3eclassName(html)))
end
local function _3_(args)
  local html = str.join("\n", vim.api.nvim_buf_get_lines(0, (args.line1 - 1), args.line2, true))
  local jsx = html__3ejsx(html)
  return vim.api.nvim_buf_set_lines(0, (args.line1 - 1), args.line2, true, str.split(jsx, "\n"))
end
return vim.api.nvim_create_user_command("ToJsx", _3_, {range = true})
