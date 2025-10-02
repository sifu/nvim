(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(fn today []
  "[[/Daily/2024-11-16|2024-11-16]]"
  (let [today (os.date "%Y-%m-%d")]
    (.. "[[/Daily/" today "|" today "]]")))

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
        :note_path_func (fn [spec]
                          (let [path (/ spec.dir (tostring spec.title))]
                            (path:with_suffix ".md")))
        :frontmatter.func (fn [note]
                            (core.merge {:date-created (today)} note.metadata))}}
