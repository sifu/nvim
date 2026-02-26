;; Shared yank across Neovim instances via a file
;; Writes yanks to a shared file and reads them on FocusGained

(local shared-yank-file (.. (vim.fn.stdpath "data") "/shared-yank"))

(var last-written nil)

(fn write-yank []
  (let [event vim.v.event]
    (when (= event.operator "y")
      (let [regtype event.regtype
            regcontents (table.concat event.regcontents "\n")
            data (.. regtype "\n" regcontents)]
        (set last-written data)
        (let [f (io.open shared-yank-file "w")]
          (when f
            (f:write data)
            (f:close)))))))

(fn read-yank []
  (let [f (io.open shared-yank-file "r")]
    (when f
      (let [data (f:read "*a")]
        (f:close)
        (when (and (not= data "") (not= data last-written))
          (set last-written data)
          (let [newline-pos (string.find data "\n")]
            (when newline-pos
              (let [regtype (string.sub data 1 (- newline-pos 1))
                    contents (string.sub data (+ newline-pos 1))]
                (vim.fn.setreg "\"" contents regtype)))))))))

(vim.api.nvim_create_autocmd "TextYankPost"
                             {:callback write-yank
                              :desc "Save yank to shared file"})

(vim.api.nvim_create_autocmd "FocusGained"
                             {:callback read-yank
                              :desc "Read shared yank on focus"})

{}
