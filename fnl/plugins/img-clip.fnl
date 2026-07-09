;; Seamless drag & drop of images into Markdown / Obsidian notes.
;;
;; Dropping an image onto kitty bracket-pastes its absolute path. We intercept
;; that paste -- only in a markdown buffer, only when it is a single existing
;; image file -- and hand it to img-clip, which copies the file into the vault's
;; assets/ folder and inserts an ![[name]] embed. Every other paste is untouched.

(local image-exts {:png true
                   :jpg true
                   :jpeg true
                   :gif true
                   :webp true
                   :avif true})

(local vault (vim.fn.expand "~/Obsidian/Main"))

(fn assets-dir []
  ;; Vault notes share the vault's assets/ folder; other markdown uses a local one.
  (if (vim.startswith (vim.fn.expand "%:p") vault)
      (.. vault "/assets")
      "assets"))

(fn dropped-image-path [lines]
  ;; The path, if `lines` is a single non-empty line naming an existing image file.
  (var only nil)
  (var n 0)
  (each [_ l (ipairs lines)]
    (when (not= (vim.trim l) "")
      (set n (+ n 1))
      (set only l)))
  (when (= n 1)
    (let [stripped (only:gsub "^file://" "")
          path (vim.trim stripped)
          ext (string.lower (vim.fn.fnamemodify path ":e"))]
      (when (and (. image-exts ext) (= 1 (vim.fn.filereadable path)))
        path))))

(fn embed-dropped-image [path]
  ;; Copy into assets/ keeping the original name, insert an ![[name]] embed.
  ;; api_opts (2nd arg) take priority over img-clip's built-in markdown template.
  (vim.schedule (fn []
                  (let [img-clip (require "img-clip")]
                    (img-clip.paste_image {:dir_path (assets-dir)
                                           ;; Full basename incl. extension: img-clip
                                           ;; only appends an ext when :e is empty, and
                                           ;; CleanShot names contain dots (08.53.30).
                                           :file_name (vim.fn.fnamemodify path
                                                                          ":t")
                                           :copy_images true
                                           :prompt_for_file_name false
                                           :insert_mode_after_paste false
                                           :template "![[$FILE_NAME]]"}
                                          path)))))

(fn install-paste-handler []
  ;; Wrap vim.paste once. Any detection error falls through to normal pasting.
  (when (not vim.g.img_clip_paste_wrapped)
    (set vim.g.img_clip_paste_wrapped true)
    (let [orig vim.paste]
      (set vim.paste (fn [lines phase]
                       (let [(ok path) (pcall (fn []
                                                (and (= vim.bo.filetype
                                                        "markdown")
                                                     (dropped-image-path lines))))]
                         (if (and ok path)
                             (do
                               (embed-dropped-image path)
                               true)
                             (orig lines phase))))))))

{1 "HakonHarnes/img-clip.nvim" :lazy true :init install-paste-handler :opts {}}
