-- [nfnl] fnl/user/code-action.fnl
local function sorted_code_action()
  local original_select = vim.ui.select
  local function _1_(items, opts, on_choice)
    vim.ui.select = original_select
    if (opts.kind == "codeaction") then
      local format_item = (opts.format_item or tostring)
      local function _2_(a, b)
        local a_title = format_item(a)
        local b_title = format_item(b)
        local a_import
        if a_title:find("^Add import") then
          a_import = true
        else
          a_import = false
        end
        local b_import
        if b_title:find("^Add import") then
          b_import = true
        else
          b_import = false
        end
        if (a_import and not b_import) then
          return true
        else
          return false
        end
      end
      table.sort(items, _2_)
    else
    end
    return original_select(items, opts, on_choice)
  end
  vim.ui.select = _1_
  return vim.lsp.buf.code_action()
end
return {["sorted-code-action"] = sorted_code_action}
