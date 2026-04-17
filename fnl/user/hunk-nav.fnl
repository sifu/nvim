(local hunks-title "Git hunks")

(fn tag-list []
  (vim.fn.setqflist [] "a" {:title hunks-title}))

(fn hunks-list-current? []
  (let [info (vim.fn.getqflist {:title true :size true})]
    (and (= info.title hunks-title) (> info.size 0))))

(fn populate [open?]
  (let [gitsigns (require "gitsigns")]
    (gitsigns.setqflist "all" {:open open?} tag-list)))

(fn populate_all_hunks []
  (populate true))

(fn preview-after-attach []
  (vim.schedule (fn []
                  (pcall (. (require "gitsigns") "preview_hunk")))))

(fn jump-and-preview [cmd]
  (let [(ok _) (pcall cmd)]
    (when ok
      (preview-after-attach))))

(fn navigate [direction]
  (let [cmd (if (= direction "next") vim.cmd.cnext vim.cmd.cprev)]
    (if (hunks-list-current?)
        (jump-and-preview cmd)
        (let [gitsigns (require "gitsigns")]
          (gitsigns.setqflist "all" {:open false}
                              (fn []
                                (tag-list)
                                (jump-and-preview cmd)))))))

(fn next_hunk_global []
  (navigate "next"))

(fn prev_hunk_global []
  (navigate "prev"))

{: populate_all_hunks : next_hunk_global : prev_hunk_global}
