(fn setup []
  (set vim.g.startify_list [{:type "files"
                             :header [" Files"]
                             :type "files"
                             :header [" Files"]
                             :type "files"
                             :header [" Files"]}])
  (set vim.g.startify_bookmarks [{:t "~/.tmux.conf" :z "~/.zshrc"}])
  (set vim.g.startify_session_delete_buffers 1)
  (set vim.g.startify_session_persistence 1)
  (set vim.g.startify_enable_special 0)
  (set vim.g.startify_custom_header ""))

{1 "mhinz/vim-startify" :init setup}
