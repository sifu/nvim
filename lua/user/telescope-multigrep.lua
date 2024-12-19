-- [nfnl] Compiled from fnl/user/telescope-multigrep.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local function multigrep()
  local opts = themes.get_ivy({cwd = vim.uv.cwd()})
  local finder
  local function _2_(prompt)
    if (not prompt or (prompt == "")) then
      return nil
    else
      local pieces = vim.split(prompt, "  ")
      local args = {"rg"}
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      else
      end
      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      else
      end
      return core.concat(args, {"--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "!fontawesome", "--iglob", "!.git", "--smart-case"})
    end
  end
  finder = finders.new_async_job({command_generator = _2_, entry_maker = make_entry.gen_from_vimgrep(opts), cwd = opts.cwd})
  local picker = pickers.new(opts, {finder = finder, prompt_title = "Multi Grep", debounce = 100, previewer = conf.values.grep_previewer(opts), sorter = sorters.empty()})
  return picker:find()
end
return {multigrep = multigrep}
