(local wk (require "which-key"))

(set vim.g.markdown_recommended_style 0)

(fn toggle-todo-line [line]
  "Toggle todo state of a markdown line. Returns the modified line."
  (if (string.match line "- %[.%]")
      (if (string.match line "- %[ %]")
          (string.gsub line "- %[ %]" "- [x]")
          (string.gsub line "- %[.%]" "- [ ]"))
      (if (string.match line "^%s*- ")
          (string.gsub line "^(%s*- )" "%1[ ] ")
          line)))

(fn toggle-todo []
  (let [line (vim.api.nvim_get_current_line)
        new-line (toggle-todo-line line)]
    (when (not= line new-line)
      (vim.api.nvim_set_current_line new-line))))

(fn cross-out-todo []
  (let [line (vim.api.nvim_get_current_line)]
    (if (string.match line "- %[.%]")
        (let [new-line (string.gsub line "- %[.%]" "- [-]")]
          (vim.api.nvim_set_current_line new-line)))))

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "markdown"
                              :callback (fn []
                                          (set vim.opt_local.cursorline false)
                                          (set vim.opt_local.wrap true)
                                          (set vim.opt_local.linebreak true)
                                          (set vim.opt_local.textwidth 0)
                                          (set vim.opt_local.number false)
                                          (set vim.opt_local.relativenumber
                                               false)
                                          (wk.add [["<c-space>"
                                                    toggle-todo
                                                    {:buffer 0
                                                     :desc "Toggle Todo"}]
                                                   ["glt"
                                                    toggle-todo
                                                    {:buffer 0
                                                     :desc "Toggle Todo"}]
                                                   ["glx"
                                                    cross-out-todo
                                                    {:buffer 0
                                                     :desc "Cross out Todo"}]]))})
