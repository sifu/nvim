;; Show the JSON path to the current cursor position as virtual text

(local ns (vim.api.nvim_create_namespace "json-path"))

(fn get-json-path [buf]
  "Build the JSON key path at the cursor by walking up the treesitter tree."
  (let [(ok parser) (pcall vim.treesitter.get_parser buf "json")]
    (when (not ok)
      (lua "return nil"))
    (parser:parse)
    (let [cursor (vim.api.nvim_win_get_cursor 0)
          row (- (. cursor 1) 1)
          line (. (vim.api.nvim_buf_get_lines buf row (+ row 1) false) 1)
          first-nonblank (when line (line:find "[^%s]"))
          col (if first-nonblank (- first-nonblank 1) (. cursor 2))
          node (vim.treesitter.get_node {:bufnr buf :pos [row col]})]
      (when (= node nil)
        (lua "return nil"))
      (var parts [])
      (var current node)
      (while (not= current nil)
        (let [node-type (current:type)]
          (when (= node-type "pair")
            (let [key-node (current:named_child 0)]
              (when (not= key-node nil)
                (let [key-text (vim.treesitter.get_node_text key-node buf)
                      clean (key-text:match "^\"(.-)\"$")]
                  (table.insert parts 1 (or clean key-text))))))
          (when (= node-type "array")
            (var idx 0)
            (let [child-count (current:named_child_count)]
              (for [i 0 (- child-count 1)]
                (let [child (current:named_child i)
                      (sr sc er ec) (child:range)
                      (nr nc) (values (node:start))]
                  (when (or (< nr sr) (and (= nr sr) (< nc sc)))
                    (lua "break"))
                  (set idx i))))
            (table.insert parts 1 (.. "[" idx "]"))))
        (set current (current:parent)))
      (when (= (length parts) 0)
        (lua "return nil"))
      (let [raw (table.concat parts ".")]
        (raw:gsub "%.%[" "[")))))

(let [group (vim.api.nvim_create_augroup "json-path" {:clear true})]
  (vim.api.nvim_create_autocmd ["CursorMoved" "CursorMovedI"]
                               {: group
                                :callback (fn []
                                            (let [buf (vim.api.nvim_get_current_buf)]
                                              (vim.api.nvim_buf_clear_namespace buf
                                                                                ns
                                                                                0
                                                                                -1)
                                              (when (= vim.bo.filetype "json")
                                                (let [(ok path) (pcall get-json-path
                                                                       buf)]
                                                  (when (and ok path)
                                                    (let [row (- (vim.fn.line ".")
                                                                 1)]
                                                      (vim.api.nvim_buf_set_extmark buf
                                                                                    ns
                                                                                    row
                                                                                    0
                                                                                    {:virt_text [[path
                                                                                                  "Comment"]]
                                                                                     :virt_text_pos "eol"}))))))
                                            nil)}))

{: get-json-path}
