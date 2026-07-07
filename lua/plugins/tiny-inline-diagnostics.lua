-- [nfnl] fnl/plugins/tiny-inline-diagnostics.fnl
vim.diagnostic.config({virtual_text = false})
return {"rachartier/tiny-inline-diagnostic.nvim", event = "VeryLazy", opts = {preset = "modern", options = {multilines = {enabled = true}}}, config = true}
