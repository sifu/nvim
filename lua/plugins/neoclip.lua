-- [nfnl] fnl/plugins/neoclip.fnl
return {"AckslD/nvim-neoclip.lua", event = "VeryLazy", dependencies = {{"kkharji/sqlite.lua", module = "sqlite"}}, opts = {enable_persistent_history = true, continuous_sync = true, keys = {telescope = {i = {select = "<c-space>", paste = "<cr>", paste_behind = "<c-P>"}}}}}
