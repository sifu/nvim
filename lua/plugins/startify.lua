-- [nfnl] fnl/plugins/startify.fnl
local function setup()
  vim.g.startify_list = {{type = "files", header = {" Files"}}}
  vim.g.startify_bookmarks = {{t = "~/.tmux.conf", z = "~/.zshrc"}}
  vim.g.startify_session_delete_buffers = 1
  vim.g.startify_session_persistence = 1
  vim.g.startify_enable_special = 0
  vim.g.startify_custom_header = ""
  vim.g.startify_session_before_save = {"lua pcall(require('neogit').close)"}
  return nil
end
return {"mhinz/vim-startify", init = setup}
