(local wk (require "which-key"))

(set vim.g.markdown_recommended_style 0)

(fn toggle-todo-line [line]
  "Toggle todo state of a markdown line. Returns the modified line."
  (if (string.match line "- %[.%]")
      ; Already has a todo checkbox - toggle its state
      (if (string.match line "- %[ %]")
          (string.gsub line "- %[ %]" "- [x]")
          (string.gsub line "- %[.%]" "- [ ]"))
      ; No todo checkbox - check if it's a list item that can be converted
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

; Tests for toggle-todo-line function
(fn test-toggle-todo []
  (let [tests [; Test case: plain list item should become todo
               ["- blabla muh kuh" "- [ ] blabla muh kuh"]
               ; Test case: indented list item should become todo
               ["  - item" "  - [ ] item"]
               ; Test case: unchecked todo should become checked
               ["- [ ] task" "- [x] task"]
               ; Test case: checked todo should become unchecked
               ["- [x] done task" "- [ ] done task"]
               ; Test case: crossed out todo should become unchecked
               ["- [-] crossed" "- [ ] crossed"]
               ; Test case: non-list line should remain unchanged
               ["regular text" "regular text"]]]
    (each [i [input expected] (ipairs tests)]
      (let [result (toggle-todo-line input)]
        (if (= result expected)
            (print (string.format "✓ Test %d passed: '%s' -> '%s'" i input
                                  result))
            (print (string.format "✗ Test %d failed: '%s' -> '%s' (expected '%s')"
                                  i input result expected)))))))

; Uncomment the line below to run tests:
; (test-toggle-todo)

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "markdown"
                              :callback (fn []
                                          (wk.register {:glt [toggle-todo
                                                              "Toggle Todo"]
                                                        :glx [cross-out-todo
                                                              "Cross out Todo"]}
                                                       {:buffer 0}))})
