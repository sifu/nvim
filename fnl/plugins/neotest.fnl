;; TODO: keymaps
;; TODO: automatic opening of the summary when starting a test (+ a keymap to toggle it)
;; TODO: keymap to open the output

{1 "nvim-neotest/neotest"
 :dependencies ["nvim-neotest/nvim-nio"
                "nvim-lua/plenary.nvim"
                "antoinemadec/FixCursorHold.nvim"
                "nvim-treesitter/nvim-treesitter"
                "marilari88/neotest-vitest"]
 :config (fn []
           (let [neotest (require "neotest")
                 vitest (require "neotest-vitest")]
             (neotest.setup {:adapters [(vitest {:filter_dir (fn [name]
                                                               (not= name
                                                                     "node_modules"))})]
                             :summary {:open "botright vsplit | vertical resize 50"}})
             ;; Set dark background for neotest summary window
             (local set-neotest-highlights
                    (fn []
                      (let [bg "#666666"]
                        (vim.api.nvim_set_hl 0 "NeotestDir"
                                             {: bg :fg "#87CEEB"})
                        (vim.api.nvim_set_hl 0 "NeotestFile"
                                             {: bg :fg "#ffffff"})
                        (vim.api.nvim_set_hl 0 "NeotestNamespace"
                                             {: bg :fg "#90EE90"})
                        (vim.api.nvim_set_hl 0 "NeotestTest"
                                             {: bg :fg "#ffffff"})
                        (vim.api.nvim_set_hl 0 "NeotestExpandMarker"
                                             {: bg :fg "#333333"})
                        (vim.api.nvim_set_hl 0 "NeotestAdapterName"
                                             {: bg :fg "#FFA500"})
                        (vim.api.nvim_set_hl 0 "NeotestIndent"
                                             {: bg :fg "#333333"})
                        (vim.api.nvim_set_hl 0 "NeotestWinSelect"
                                             {: bg :fg "#FFA500" :bold true})
                        (vim.api.nvim_set_hl 0 "NeotestMarked"
                                             {: bg :fg "#FFD700"})
                        (vim.api.nvim_set_hl 0 "NeotestTarget"
                                             {: bg :fg "#FF6347"}))))
             ;; Set highlights now and after colorscheme changes
             (set-neotest-highlights)
             (vim.api.nvim_create_autocmd "ColorScheme"
                                          {:callback set-neotest-highlights})
             (vim.api.nvim_create_autocmd "BufWinEnter"
                                          {:pattern "*"
                                           :callback (fn []
                                                       (let [bufname (vim.api.nvim_buf_get_name 0)]
                                                         (when (string.match bufname
                                                                             "Neotest Summary")
                                                           (vim.api.nvim_set_option_value "winhighlight"
                                                                                          "Normal:NeotestDir,NormalNC:NeotestDir,WinBar:NeotestDir,WinBarNC:NeotestDir"
                                                                                          {:scope "local"})
                                                           (vim.api.nvim_set_option_value "cursorline"
                                                                                          false
                                                                                          {:scope "local"}))))})))}
