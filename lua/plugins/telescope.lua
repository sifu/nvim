-- [nfnl] Compiled from fnl/plugins/telescope.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local themes = require("telescope.themes")
  telescope.setup({defaults = {file_ignore_patterns = {"node_modules", "lua/plugins", "lua/config"}, dynamic_preview_title = true, mappings = {i = {["<esc>"] = actions.close, ["<c-q>"] = (actions.send_to_qflist + actions.open_qflist), ["<c-f>"] = (actions.send_selected_to_qflist + actions.open_qflist), ["<tab>"] = (actions.toggle_selection + actions.move_selection_better), ["<s-tab>"] = (actions.toggle_selection + actions.move_selection_worse), ["<c-c>"] = actions.delete_buffer, ["<c-u>"] = actions.preview_scrolling_up, ["<c-d>"] = actions.preview_scrolling_down}}, vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--iglob", "!.git", "--hidden"}}, extensions = {["ui-select"] = {themes.get_dropdown({})}, sessions_picker = {sessions_dir = (vim.fn.stdpath("data") .. "/session/")}}, pickers = {find_files = {find_command = {"rg", "--files", "--iglob", "!fontawesome", "--iglob", "!.git", "--hidden"}}}})
  telescope.load_extension("ui-select")
  telescope.load_extension("oil")
  telescope.load_extension("fzf")
  telescope.load_extension("tailiscope")
  return telescope.load_extension("sessions_picker")
end
return {"nvim-telescope/telescope.nvim", dependencies = {"nvim-telescope/telescope-ui-select.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "albenisolmos/telescope-oil.nvim", "danielvolchek/tailiscope.nvim", "JoseConseco/telescope_sessions_picker.nvim"}, config = _1_}
