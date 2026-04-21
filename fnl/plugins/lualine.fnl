(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(fn lsp-connection []
  (let [status (vim.lsp.status)]
    (if (and (not= status "") (not= status nil)) (.. " " status)
        (not (vim.tbl_isempty (vim.lsp.get_clients {:bufnr 0}))) ""
        "")))

(fn merge-conflict []
  (let [git-dir (vim.fn.finddir ".git" ".;")]
    (if (or (= git-dir "") (= git-dir nil))
        ""
        (let [merge (vim.fn.filereadable (.. git-dir "/MERGE_HEAD"))
              rebase (vim.fn.isdirectory (.. git-dir "/rebase-merge"))
              cherry (vim.fn.filereadable (.. git-dir "/CHERRY_PICK_HEAD"))]
          (if (= merge 1) "MERGE CONFLICT"
              (= rebase 1) "REBASING"
              (= cherry 1) "CHERRY-PICK"
              "")))))

(fn macro-recording []
  (if (core.empty? (vim.fn.reg_recording)) ""
      (.. "🔴@" (vim.fn.reg_recording))))

(fn claude-busy []
  (let [(ok val) (pcall (fn [] (. (vim.bo 0) "busy")))]
    (if (and ok val (> val 0)) "Claude…" "")))

(vim.api.nvim_create_autocmd "User"
                             {:pattern "ClaudeBusyChanged"
                              :callback (fn []
                                          (let [lualine (require "lualine")]
                                            (lualine.refresh {:place ["statusline"]})))})

(vim.api.nvim_create_autocmd "RecordingEnter"
                             {:callback (fn []
                                          (let [lualine (require "lualine")]
                                            (lualine.refresh {:place ["statusline"]})))})

(vim.api.nvim_create_autocmd "RecordingLeave"
                             {:callback (fn []
                                          (let [lualine (require "lualine")
                                                timer (vim.loop.new_timer)]
                                            (timer:start 50 0
                                                         (vim.schedule_wrap (fn []
                                                                              (lualine.refresh {:place ["statusline"]}))))))})

{1 "nvim-lualine/lualine.nvim"
 :config (fn []
           (let [lualine (require "lualine")
                 lualine-theme (require "lualine.themes.material")]
             (lualine.setup {:options {:theme lualine-theme
                                       :icons_enabled true
                                       :component_separators {:left ""
                                                              :right ""}
                                       :section_separators {:left ""
                                                            :right ""}}
                             :sections {:lualine_a ["mode" {:upper true}]
                                        :lualine_b ["branch"
                                                    {1 "diff"
                                                     :diff_color {:modified {:fg "#87afff"}}}]
                                        :lualine_c [{1 "filename"
                                                     :file_status true
                                                     :path 1
                                                     :shorting_target 40}
                                                    [macro-recording]
                                                    {1 claude-busy
                                                     :color {:fg "#d4a373"
                                                             :gui "bold"}}
                                                    {1 merge-conflict
                                                     :color {:fg "#ff0000"
                                                             :gui "bold"}}]
                                        :lualine_x [[lsp-connection]
                                                    "location"
                                                    "progress"
                                                    "filetype"]
                                        :lualine_y ["encoding"]
                                        :lualine_z []}
                             :inactive_sections {:lualine_a []
                                                 :lualine_b []
                                                 :lualine_c [{1 "filename"
                                                              :file_status true
                                                              :path 1}]
                                                 :lualine_x []
                                                 :lualine_y []
                                                 :lualine_z []}})))}
