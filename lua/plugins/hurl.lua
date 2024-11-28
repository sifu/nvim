-- [nfnl] Compiled from fnl/plugins/hurl.fnl by https://github.com/Olical/nfnl, do not edit.
return {"jellydn/hurl.nvim", dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, ft = "hurl", opts = {mode = "split", formatters = {json = {"jq"}, html = {"prettier", "--parser", "html"}, xml = {"tidy", "-xml", "-i", "-q"}}, mappings = {close = "q", next_panel = "<C-n>", prev_panel = "<C-p>"}, debug = false, show_notification = false}, keys = {{"<leader>hA", "<cmd>HurlRunner<CR>", desc = "Run All requests"}, {"<leader>ha", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request"}, {"<leader>hte", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry"}, {"<leader>htE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end"}, {"<leader>htm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode"}, {"<leader>htv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode"}, {"<leader>htV", "<cmd>HurlVeryVerbose<CR>", desc = "Run Api in very verbose mode"}, {"<leader>hh", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v"}}}
