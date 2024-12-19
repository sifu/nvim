(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(local pickers (require "telescope.pickers"))
(local finders (require "telescope.finders"))
(local make_entry (require "telescope.make_entry"))
(local conf (require "telescope.config"))
(local sorters (require "telescope.sorters"))
(local themes (require "telescope.themes"))

(fn multigrep []
  (let [opts (themes.get_ivy {:cwd (vim.uv.cwd)})]
    (local finder
           (finders.new_async_job {:command_generator (fn [prompt]
                                                        (if (or (not prompt)
                                                                (= prompt ""))
                                                            nil
                                                            (let [pieces (vim.split prompt
                                                                                    "  ")
                                                                  args ["rg"]]
                                                              (when (. pieces 1)
                                                                (table.insert args
                                                                              "-e")
                                                                (table.insert args
                                                                              (. pieces
                                                                                 1)))
                                                              (when (. pieces 2)
                                                                (table.insert args
                                                                              "-g")
                                                                (table.insert args
                                                                              (. pieces
                                                                                 2)))
                                                              (core.concat args
                                                                           ["--color=never"
                                                                            "--no-heading"
                                                                            "--with-filename"
                                                                            "--line-number"
                                                                            "--column"
                                                                            "!fontawesome"
                                                                            "--iglob"
                                                                            "!.git"
                                                                            "--smart-case"]))))
                                   :entry_maker (make_entry.gen_from_vimgrep opts)
                                   :cwd (. opts "cwd")}))
    (local picker (pickers.new opts
                               {: finder
                                :prompt_title "Multi Grep"
                                :debounce 100
                                :previewer (conf.values.grep_previewer opts)
                                :sorter (sorters.empty)}))
    (picker:find)))

{: multigrep}
