;; Inline image rendering in Markdown / Obsidian notes via the Kitty graphics
;; protocol. Works through tmux (needs `allow-passthrough on`, already set).
;; Uses the ImageMagick CLI (`magick_cli`) so no luarock is required.

(local vault-assets (vim.fn.expand "~/Obsidian/Main/assets"))

(fn file-exists? [path]
  (and path (not= nil (vim.uv.fs_stat path))))

(fn resolve-image-path [document-path image-path fallback]
  ;; Prefer the plugin's default resolution: it handles absolute (/), ~, and
  ;; paths relative to the current note (e.g. ![](assets/foo.png)).
  (let [default (fallback document-path image-path)]
    (if (file-exists? default)
        default
        ;; Obsidian ![[bare-name.png]] embeds live in the vault's assets/ folder,
        ;; not next to the note -> look the basename up there.
        (let [name (vim.fn.fnamemodify image-path ":t")
              in-assets (.. vault-assets "/" name)]
          (if (file-exists? in-assets)
              in-assets
              default)))))

{1 "3rd/image.nvim"
 :ft ["markdown"]
 :opts {:backend "kitty"
        :processor "magick_cli"
        :integrations {:markdown {:enabled true
                                  :clear_in_insert_mode false
                                  :download_remote_images true
                                  :only_render_image_at_cursor false
                                  :filetypes ["markdown"]
                                  :resolve_image_path resolve-image-path}
                       :asciidoc {:enabled false}
                       :neorg {:enabled false}
                       :rst {:enabled false}
                       :typst {:enabled false}
                       :html {:enabled false}
                       :css {:enabled false}}
        ;; Cap the big @2x CleanShot screenshots so they don't fill the screen.
        :max_height_window_percentage 50
        ;; Hide images behind cmp/noice popups instead of painting over them.
        :window_overlap_clear_enabled true
        ;; Only draw images in the focused tmux window (visual-activity is off).
        :tmux_show_only_in_active_window true}}
