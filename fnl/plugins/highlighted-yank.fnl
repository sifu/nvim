{1 "machakann/vim-highlightedyank"
 :event "VeryLazy"
 :config (fn []
           (vim.schedule (fn []
                           (vim.cmd "highlight! IncSearch cterm=reverse gui=reverse"))))}
