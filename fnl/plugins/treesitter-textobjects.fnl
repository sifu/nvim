{1 "nvim-treesitter/nvim-treesitter-textobjects"
 :lazy true
 :config (fn []
           (let [ts (require "nvim-treesitter.configs")]
             (ts.setup {:textobjects {:select {:enable true
                                               :lookahead true
                                               :keymaps {:a= {:query "@assignment.outer"
                                                              :desc "Select outer part of an assignment"}
                                                         :i= {:query "@assignment.inner"
                                                              :desc "Select inner part of an assignment"}
                                                         :r= {:query "@assignment.rhs"
                                                              :desc "Select right hand side of an assignment"}
                                                         :ap {:query "@parameter.outer"
                                                              :desc "Select outer part of a parameter/argument"}
                                                         :ip {:query "@parameter.inner"
                                                              :desc "Select inner part of a parameter/argument"}
                                                         :ai {:query "@conditional.outer"
                                                              :desc "Select outer part of a conditional"}
                                                         :ii {:query "@conditional.inner"
                                                              :desc "Select inner part of a conditional"}
                                                         :al {:query "@loop.outer"
                                                              :desc "Select outer part of a loop"}
                                                         :il {:query "@loop.inner"
                                                              :desc "Select inner part of a loop"}
                                                         :af {:query "@call.outer"
                                                              :desc "Select outer part of a function call"}
                                                         :if {:query "@call.inner"
                                                              :desc "Select inner part of a function call"}
                                                         :am {:query "@function.outer"
                                                              :desc "Select outer part of a method/function definition"}
                                                         :im {:query "@function.inner"
                                                              :desc "Select inner part of a method/function definition"}
                                                         :ac {:query "@class.outer"
                                                              :desc "Select outer part of a class"}
                                                         :ic {:query "@class.inner"
                                                              :desc "Select inner part of a class"}}}
                                      :swap {:enable true
                                             :swap_next {:<leader>mp "@parameter.inner"
                                                         :<leader>mm "@function.outer"}
                                             :swap_previous {:<leader>mP "@parameter.inner"
                                                             :<leader>mM "@function.outer"}}}})))}
