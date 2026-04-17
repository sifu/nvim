{1 "https://github.com/lewis6991/gitsigns.nvim"
 :ft ["typescriptreact" "javascriptreact" "typescript" "javascript"]
 :keys [{1 "<leader>hq"
         2 "<cmd>lua require('user.hunk-nav').populate_all_hunks()<cr>"
         :desc "List all hunks (QF)"}
        {1 "<leader>hj"
         2 "<cmd>lua require('user.hunk-nav').next_hunk_global()<cr>"
         :desc "Next hunk (repo-wide)"}
        {1 "<leader>hk"
         2 "<cmd>lua require('user.hunk-nav').prev_hunk_global()<cr>"
         :desc "Prev hunk (repo-wide)"}]
 :opts {:signs {:add {:text "┃"
                      :change {:text "┃"}
                      :delete {:text "_"}
                      :topdelete {:text "‾"}
                      :changedelete {:text "~"}
                      :untracked {:text "┆"}}}
        :signs_staged {:add {:text "┃"}
                       :change {:text "┃"}
                       :delete {:text "_"}
                       :topdelete {:text "‾"}
                       :changedelete {:text "~"}
                       :untracked {:text "┆"}}
        :signs_staged_enable true
        :signcolumn true
        :numhl false
        :linehl false
        :word_diff false
        :watch_gitdir {:follow_files true}
        :auto_attach true
        :attach_to_untracked false
        :current_line_blame true
        :current_line_blame_opts {:virt_text true
                                  :virt_text_pos "right_align"
                                  :delay 500
                                  :ignore_whitespace false
                                  :virt_text_priority 100
                                  :use_focus true}
        :current_line_blame_formatter "<author>, <author_time:%R> - <abbrev_sha> <summary>"
        :sign_priority 6
        :update_debounce 100
        :status_formatter nil
        :max_file_length 40000
        :preview_config {:border "single"
                         :style "minimal"
                         :relative "cursor"
                         :row 0
                         :col 1}}}
