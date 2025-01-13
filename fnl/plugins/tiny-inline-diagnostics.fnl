(vim.diagnostic.config {:virtual_text false})

{1 "rachartier/tiny-inline-diagnostic.nvim"
 :event "LspAttach"
 :priority 1000
 :opts {:preset "powerline" :options {:multilines {:enabled true}}}
 :config true}
