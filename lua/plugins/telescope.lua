-- [nfnl] fnl/plugins/telescope.fnl
local select_one_or_multi
local function _1_(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if (j.path ~= nil) then
        vim.cmd(string.format("%s %s", "edit", j.path))
      else
      end
    end
    return nil
  else
    return require("telescope.actions").select_default(prompt_bufnr)
  end
end
select_one_or_multi = _1_
local function _4_()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local themes = require("telescope.themes")
  telescope.setup({defaults = {file_ignore_patterns = {"node_modules", "lua/plugins", "lua/config"}, path_display = {"truncate"}, dynamic_preview_title = true, mappings = {i = {["<cr>"] = select_one_or_multi, ["<esc>"] = actions.close, ["<c-q>"] = (actions.send_to_qflist + actions.open_qflist), ["<c-f>"] = (actions.send_selected_to_qflist + actions.open_qflist), ["<tab>"] = (actions.toggle_selection + actions.move_selection_better), ["<s-tab>"] = (actions.toggle_selection + actions.move_selection_worse), ["<c-c>"] = actions.delete_buffer, ["<c-u>"] = actions.preview_scrolling_up, ["<c-d>"] = actions.preview_scrolling_down}}, vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--iglob", "!.git", "--hidden"}}, extensions = {["ui-select"] = {themes.get_dropdown({})}, sessions_picker = {sessions_dir = (vim.fn.stdpath("data") .. "/session/")}}, pickers = {buffers = {theme = "ivy"}, git_branches = {mappings = {i = {["<cr>"] = actions.git_switch_branch}}}, find_files = {find_command = {"rg", "--files", "--iglob", "!fontawesome", "--iglob", "!.git", "--hidden"}}}})
  telescope.load_extension("ui-select")
  telescope.load_extension("oil")
  telescope.load_extension("fzf")
  telescope.load_extension("tailiscope")
  return telescope.load_extension("sessions_picker")
end
return {"nvim-telescope/telescope.nvim", dependencies = {"nvim-telescope/telescope-ui-select.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "albenisolmos/telescope-oil.nvim", "danielvolchek/tailiscope.nvim", "JoseConseco/telescope_sessions_picker.nvim"}, config = _4_}
