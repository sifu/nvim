-- [nfnl] Compiled from fnl/plugins/tiny-inline-diagnostics.fnl by https://github.com/Olical/nfnl, do not edit.
vim.diagnostic.config({virtual_text = false})
return {"rachartier/tiny-inline-diagnostic.nvim", event = "LspAttach", priority = 1000, opts = {preset = "powerline", options = {multilines = {enabled = true}}}, config = true}
