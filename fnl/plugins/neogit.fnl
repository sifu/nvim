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
                            :mappings {:status {:<esc> "Close"}
                                       :commit_editor {"€€" "Submit"}
                                       :commit_editor_I {"€€" "Submit"}}})))}
