(local pickers (require "telescope.pickers"))
(local finders (require "telescope.finders"))
(local make_entry (require "telescope.make_entry"))
(local conf (require "telescope.config"))

(fn collect-items [results]
  (let [all-items []]
    (each [client-id result (pairs results)]
      (when result.result
        (let [client (vim.lsp.get_client_by_id client-id)
              items (vim.lsp.util.locations_to_items result.result
                                                     client.offset_encoding)]
          (each [_ item (ipairs items)]
            (table.insert all-items item)))))
    all-items))

(fn dedupe-by-filename [items]
  (let [seen {}
        unique []]
    (each [_ item (ipairs items)]
      (when (not (. seen item.filename))
        (tset seen item.filename true)
        (table.insert unique item)))
    unique))

(fn show-picker [items]
  (let [picker (pickers.new {}
                            {:finder (finders.new_table {:results items
                                                         :entry_maker (make_entry.gen_from_quickfix {})})
                             :prompt_title "References (unique files)"
                             :previewer (conf.values.qflist_previewer {})
                             :sorter (conf.values.generic_sorter {})})]
    (picker:find)))

(fn references []
  (let [bufnr (vim.api.nvim_get_current_buf)
        params (vim.lsp.util.make_position_params)]
    (tset params "context" {:includeDeclaration true})
    (vim.lsp.buf_request_all bufnr "textDocument/references" params
                             (fn [results]
                               (let [unique (dedupe-by-filename (collect-items results))]
                                 (when (> (length unique) 0)
                                   (vim.schedule #(show-picker unique))))))))

{: references}
