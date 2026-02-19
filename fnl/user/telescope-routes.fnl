(local pickers (require "telescope.pickers"))
(local finders (require "telescope.finders"))
(local conf (require "telescope.config"))

(local route-file "/s/prj/frontend-demo/src/route-definitions.tsx")
(local base-dir "/s/prj/frontend-demo/src")

(fn resolve-import-path [import-path]
  (let [normalized (-> import-path
                       (: "gsub" "^@/" "")
                       (: "gsub" "^%./" "")
                       (: "gsub" "/%./" "/"))
        full-base (.. base-dir "/" normalized)
        extensions [".tsx" ".ts" ".jsx" ".js"]]
    (var result nil)
    (each [_ ext (ipairs extensions) &until result]
      (let [path (.. full-base ext)]
        (when (= (vim.fn.filereadable path) 1)
          (set result path))))
    result))

(fn parse-routes []
  (let [lines (vim.fn.readfile route-file)
        imports {}
        entries []]
    (var pending-lazy-name nil)
    (var depth 0)
    (var in-routes false)
    (local path-at-depth {})
    (each [_ line (ipairs lines)]
      ;; Single-line lazy imports
      (let [(name import-path) (line:match "const%s+(%w+)%s*=%s*lazy%(%s*%(%)%s*=>%s*import%('([^']+)'%)")]
        (when (and name import-path)
          (tset imports name import-path)))
      ;; Multi-line lazy imports (first line)
      (when (not pending-lazy-name)
        (let [(name) (line:match "^const%s+(%w+)%s*=%s*lazy%(")]
          (when (and name (not (line:match "import%(")))
            (set pending-lazy-name name))))
      ;; Multi-line lazy imports (import line)
      (when pending-lazy-name
        (let [(import-path) (line:match "import%('([^']+)'%)")]
          (when import-path
            (tset imports pending-lazy-name import-path)
            (set pending-lazy-name nil))))
      ;; Detect route definitions start
      (when (line:match "routeDefinitions")
        (set in-routes true))
      ;; Parse route structure
      (when in-routes
        (each [char (line:gmatch "[{}]")]
          (if (= char "{")
              (set depth (+ depth 1))
              (do
                (tset path-at-depth depth nil)
                (set depth (- depth 1)))))
        (let [(path-val) (line:match "path:%s*'([^']+)'")]
          (when path-val
            (tset path-at-depth depth path-val)))
        (each [component (line:gmatch "<(%w+)")]
          (when (. imports component)
            (local segments [])
            (for [d 1 depth]
              (let [seg (. path-at-depth d)]
                (when (and seg (not= seg "/"))
                  (table.insert segments seg))))
            (table.insert entries
                          {:full_path (.. "/" (table.concat segments "/"))
                           : component})))))
    (values entries imports)))

(fn routes []
  (when (not= (vim.fn.filereadable route-file) 1)
    (vim.notify (.. "Route file not found: " route-file) vim.log.levels.ERROR)
    (lua "return"))
  (let [(entries imports) (parse-routes)
        results []]
    (each [_ entry (ipairs entries)]
      (let [import-path (. imports entry.component)
            file-path (resolve-import-path import-path)]
        (when file-path
          (table.insert results
                        {:display (.. entry.full_path " <" entry.component
                                      " />")
                         :file_path file-path}))))
    (let [picker (pickers.new {}
                              {:prompt_title "Routes"
                               :finder (finders.new_table {: results
                                                           :entry_maker (fn [item]
                                                                          {:value item
                                                                           :display item.display
                                                                           :ordinal item.display
                                                                           :path item.file_path})})
                               :sorter (conf.values.generic_sorter {}
                                                                   "previewer"
                                                                   (conf.values.file_previewer {}))})]
      (picker:find))))

{: routes}
