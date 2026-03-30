(fn my-smart-action []
  (let [obsidian (require "obsidian")
        cursor-link obsidian.api.cursor_link
        cursor-tag obsidian.api.cursor_tag]
    (if (cursor-link) (vim.cmd "Obsidian follow_link")
        (cursor-tag) (vim.cmd "Obsidian tags")
        (vim.cmd "Telescope buffers"))))

(vim.api.nvim_create_autocmd "User"
                             {:pattern "ObsidianNoteEnter"
                              :callback (fn [ev]
                                          ;; Gobal mappings: 
                                          ;; ,o: open obsidian
                                          ;; ,s: quick switch
                                          ;; ,i: add to inbox
                                          ;; ,n: new note
                                          (vim.keymap.set "n" "gf"
                                                          "<cmd>Obsidian follow_link<cr>"
                                                          {:buffer ev.buf
                                                           :desc "Follow Link"})
                                          (vim.keymap.set "n" ",O"
                                                          "<cmd>Obsidian open<cr>"
                                                          {:buffer ev.buf
                                                           :desc "Open in App"})
                                          (vim.keymap.set "n" ",s"
                                                          "<cmd>Obsidian quick_switch<cr>"
                                                          {:buffer ev.buf
                                                           :desc "Quick Switch"})
                                          (vim.keymap.set "n" ",b"
                                                          "<cmd>Obsidian backlinks<cr>"
                                                          {:buffer ev.buf
                                                           :desc "Backlinks"})
                                          (vim.keymap.set "n" ",t"
                                                          "<cmd>Obsidian tags<cr>"
                                                          {:buffer ev.buf
                                                           :desc "Tags"})
                                          (vim.keymap.set "n" "<CR>"
                                                          my-smart-action
                                                          {:buffer ev.buf}))})

{1 "obsidian-nvim/obsidian.nvim"
 :dependencies ["nvim-lua/plenary.nvim"]
 :opts {:workspaces [{:name "Main" :path "~/Obsidian/Main"}]
        :new_notes_location "Notes"
        :legacy_commands false
        :ui {:enable false}
        :open {:func (fn [uri]
                       (vim.ui.open uri
                                    {:cmd ["open"
                                           "-a"
                                           "/Applications/Obsidian.app"]}))}
        :completion {:min_chars 0}
        :daily_notes {:folder "Daily"}
        :note_id_func (fn [title]
                        (if (and title (not= title ""))
                            (do
                              (when (title:find "[*\"\\/<>:|?#%^%[%]]")
                                (vim.notify (.. "Invalid filename characters in: "
                                                title)
                                            vim.log.levels.ERROR)
                                (error "Invalid filename characters"))
                              title)
                            (tostring (vim.fn.strftime "%Y%m%d-%H%M%S"))))
        :note_path_func (fn [spec]
                          (let [path (/ spec.dir "Notes" (tostring spec.id))]
                            (path:with_suffix ".md")))
        :note {:template nil}
        :frontmatter {:enabled false}}}
