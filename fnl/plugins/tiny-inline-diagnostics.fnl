(vim.diagnostic.config {:virtual_text false})

{1 "rachartier/tiny-inline-diagnostic.nvim"
 :event "VeryLazy"
 :priority 1000
 :opts {:preset "modern" :options {:multilines {:enabled true}}}
 :config true}
