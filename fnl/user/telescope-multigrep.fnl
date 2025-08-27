(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(local pickers (require "telescope.pickers"))
(local finders (require "telescope.finders"))
(local make_entry (require "telescope.make_entry"))
(local conf (require "telescope.config"))
(local sorters (require "telescope.sorters"))

(fn command-generator [prompt]
  (if (or (not prompt) (= prompt ""))
      nil
      (let [pieces (vim.split prompt "  ")
            args ["rg"]]
        (when (. pieces 1)
          (table.insert args "-e")
          (table.insert args (. pieces 1)))
        (when (. pieces 2)
          (table.insert args "-g")
          (table.insert args (. pieces 2)))
        (core.concat args ["--color=never"
                           "--no-heading"
                           "--with-filename"
                           "--line-number"
                           "--column"
                           "--iglob"
                           "!.git"
                           "--smart-case"]))))

(fn multigrep []
  (local finder (finders.new_async_job {:command_generator command-generator
                                        :entry_maker (make_entry.gen_from_vimgrep {})
                                        :cwd (vim.uv.cwd)}))
  (local picker (pickers.new {}
                             {: finder
                              :prompt_title "Multi Grep"
                              :debounce 100
                              :previewer (conf.values.grep_previewer {})
                              :sorter (sorters.empty)}))
  (picker:find))

{: multigrep}
