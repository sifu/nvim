; TODO: :MasonInstall sonarlint-language-server

{1 "https://gitlab.com/schrieveslaach/sonarlint.nvim"
 :config (fn []
           (let [sonarlint (require "sonarlint")]
             (sonarlint.setup {:server {:cmd ["sonarlint-language-server"
                                              "-stdio"
                                              "-analyzers"
                                              (vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjs.jar")]}
                               :filetypes ["javascript"
                                           "javascriptreact"
                                           "typescript"
                                           "typescriptreact"]})))}
