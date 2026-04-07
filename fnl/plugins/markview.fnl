(local {: autoload} (require "nfnl.module"))

(local core (autoload "nfnl.core"))

(fn set-filetype-options [] (core.assoc vim.o "tabstop" 2)
  (core.assoc vim.o "shiftwidth" 2)
  (core.assoc vim.o "softtabstop" 2))

(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "markdown"
                              :callback (fn []
                                          (vim.keymap.set "n" ",T"
                                                          "<cmd>Markview toggle<cr>"
                                                          {:buffer true
                                                           :desc "Toggle Markview"}))})

{1 "OXY2DEV/markview.nvim"
 :ft ["markdown"]
 :cmd ["Markview"]
 :dependencies ["nvim-treesitter/nvim-treesitter"
                "nvim-tree/nvim-web-devicons"]
 :opts {:preview {:modes ["n" "c" "t"] :enable_hybrid_mode false}
        :markdown {:headings {:enable true
                              :shift_width 0
                              :heading_1 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading1"}
                              :heading_2 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading2"}
                              :heading_3 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading3"}
                              :heading_4 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading4"}
                              :heading_5 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading5"}
                              :heading_6 {:style "icon"
                                          :icon " "
                                          :hl "MarkviewHeading6"}}
                   :code_blocks {:enable false}
                   :list_items {:enable true
                                :checkboxes {:enable true
                                             :checked {:text "󰗠"
                                                       :hl "MarkviewCheckboxChecked"}
                                             :unchecked {:text "󰄰"
                                                         :hl "MarkviewCheckboxUnchecked"}}}}}
 :config (fn [_ opts]
           (let [markview (require "markview")]
             (tset opts.markdown.list_items.checkboxes "-"
                   {:text "󱋭 " :hl "MarkviewCheckboxCancelled"})
             (markview.setup opts)
             (vim.api.nvim_create_autocmd "FileType"
                                          {:pattern "markdown"
                                           :callback set-filetype-options})))}
