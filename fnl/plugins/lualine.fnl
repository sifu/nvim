(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local lsp (autoload "config.lsp"))

(fn lsp-connection []
  (let [message (lsp.get-progress-message)]
    (if ; if has progress handler and is loading
        (or (= message.status "begin") (= message.status "report"))
        (.. message.msg " : " message.percent "%% ") ; if has progress handler and finished loading
        (= message.status "end")
        "" ; if hasn't progress handler, but has connected lsp client
        (and (= message.status "")
             (not (vim.tbl_isempty (vim.lsp.get_clients 0))))
        "" ; else
        "")))

(fn macro-recording []
  (if (core.empty? (vim.fn.reg_recording)) ""
      (.. "🔴@" (vim.fn.reg_recording))))

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
                                                    [macro-recording]]
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
