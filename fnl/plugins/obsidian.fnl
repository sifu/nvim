(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(fn today []
  "[[/Daily/2024-11-16|2024-11-16]]"
  (let [today (os.date "%Y-%m-%d")]
    (.. "[[/Daily/" today "|" today "]]")))

{1 "epwalsh/obsidian.nvim"
 :version "*"
 :lazy true
 :ft "markdown"
 :dependencies ["nvim-lua/plenary.nvim"]
 :opts {:workspaces [{:name "Main" :path "~/Obsidian/Main"}]
        :ui {:enable false}
        :use_advanced_uri true
        :open_app_foreground true
        :completion {:min_chars 1}
        :note_path_func (fn [spec]
                          (let [path (/ spec.dir (tostring spec.title))]
                            (path:with_suffix ".md")))
        :note_frontmatter_func (fn [note]
                                 (core.merge {:date-created (today)}
                                             note.metadata))}}
