(fn sorted-code-action []
  (let [original-select vim.ui.select]
    (set vim.ui.select
         (fn [items opts on-choice]
           ;; Restore original immediately
           (set vim.ui.select original-select)
           ;; Sort when kind is codeaction: "Add import" first
           (when (= opts.kind "codeaction")
             (let [format-item (or opts.format_item tostring)]
               (table.sort items
                           (fn [a b]
                             (let [a-title (format-item a)
                                   b-title (format-item b)
                                   a-import (if (a-title:find "^Add import")
                                                true
                                                false)
                                   b-import (if (b-title:find "^Add import")
                                                true
                                                false)]
                               (if (and a-import (not b-import)) true false))))))
           (original-select items opts on-choice)))
    (vim.lsp.buf.code_action)))

{: sorted-code-action}
