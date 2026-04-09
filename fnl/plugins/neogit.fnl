(fn toggle-file-fold []
  "Toggle the parent file fold, even when cursor is on a hunk.
   Walks up the component tree to find the Item (file) level."
  (let [status (require "neogit.buffers.status")
        instance (status.instance)]
    (when (and instance instance.buffer instance.buffer.ui)
      (let [fold (instance.buffer.ui:get_fold_under_cursor)]
        (when fold
          ;; Walk up to the Item (file) level, but don't go past it into Section
          (var target fold)
          (var found-item false)
          ;; First check if we can find an Item ancestor
          (var node target)
          (while node
            (when (and node.options (= node.options.tag "Item"))
              (set target node)
              (set found-item true))
            (set node node.parent))
          ;; If no Item ancestor found (e.g. already on a Section), use original fold
          (when (not found-item)
            (set target fold))
          (if target.options.on_open
              (target.options.on_open target instance.buffer.ui)
              (let [(start _) (target:row_range_abs)]
                (instance.buffer:move_cursor start)
                (let [(ok _) (pcall vim.cmd "normal! za")]
                  (when ok
                    (set target.options.folded (not target.options.folded)))))))))))

{1 "NeogitOrg/neogit"
 :cmd "Neogit"
 :dependencies ["nvim-lua/plenary.nvim"
                "sindrets/diffview.nvim"
                "nvim-telescope/telescope.nvim"]
 :config (fn []
           (let [neogit (require "neogit")]
             (neogit.setup {:integrations {:telescope true :diffview true}
                            :disable_hint true
                            :graph_style "kitty"
                            :kind "replace"
                            :sections {:recent {:folded false :hidden false}}
                            :mappings {:status {:<esc> "Close"
                                                :<tab> toggle-file-fold
                                                :za toggle-file-fold}
                                       :commit_editor {"€€" "Submit"}
                                       :commit_editor_I {"€€" "Submit"}}})))}
