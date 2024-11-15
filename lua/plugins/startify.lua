-- [nfnl] Compiled from fnl/plugins/startify.fnl by https://github.com/Olical/nfnl, do not edit.
local function setup()
  vim.g.startify_list = {{type = "files", header = {" Files"}}}
  vim.g.startify_bookmarks = {{t = "~/.tmux.conf", z = "~/.zshrc"}}
  vim.g.startify_session_delete_buffers = 1
  vim.g.startify_session_persistence = 1
  vim.g.startify_enable_special = 0
  vim.g.startify_custom_header = ""
  return nil
end
return {"mhinz/vim-startify", init = setup}
