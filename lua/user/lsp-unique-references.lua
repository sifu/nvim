-- [nfnl] fnl/user/lsp-unique-references.fnl
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config")
local function collect_items(results)
  local all_items = {}
  for client_id, result in pairs(results) do
    if result.result then
      local client = vim.lsp.get_client_by_id(client_id)
      local items = vim.lsp.util.locations_to_items(result.result, client.offset_encoding)
      for _, item in ipairs(items) do
        table.insert(all_items, item)
      end
    else
    end
  end
  return all_items
end
local function dedupe_by_filename(items)
  local seen = {}
  local unique = {}
  for _, item in ipairs(items) do
    if not seen[item.filename] then
      seen[item.filename] = true
      table.insert(unique, item)
    else
    end
  end
  return unique
end
local function show_picker(items)
  local picker = pickers.new({}, {finder = finders.new_table({results = items, entry_maker = make_entry.gen_from_quickfix({})}), prompt_title = "References (unique files)", previewer = conf.values.qflist_previewer({}), sorter = conf.values.generic_sorter({})})
  return picker:find()
end
local function references()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params()
  params["context"] = {includeDeclaration = true}
  local function _3_(results)
    local unique = dedupe_by_filename(collect_items(results))
    if (#unique > 0) then
      local function _4_()
        return show_picker(unique)
      end
      return vim.schedule(_4_)
    else
      return nil
    end
  end
  return vim.lsp.buf_request_all(bufnr, "textDocument/references", params, _3_)
end
return {references = references}
