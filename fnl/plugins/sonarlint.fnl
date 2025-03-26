; TODO: :MasonInstall sonarlint-language-server

{1 "https://gitlab.com/schrieveslaach/sonarlint.nvim"
 :config (fn []
           (let [sonarlint (require "sonarlint")]
             (sonarlint.setup {:server {:cmd ["sonarlint-language-server"
                                              "-stdio"
                                              "-analyzers"
                                              (vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjs.jar")]
                                        :settings {:sonarlint {:rules {"typescript:S6660" {:level "off"}
                                                                       "typescript:S6819" {:level "off"}
                                                                       "typescript:S6478" {:level "off"}}}}}
                               :filetypes ["javascript"
                                           "javascriptreact"
                                           "typescript"
                                           "typescriptreact"]})))}
