-- [nfnl] fnl/plugins/todo-comments.fnl
return {"folke/todo-comments.nvim", event = {"BufReadPost", "BufNewFile"}, cmd = {"TodoTelescope", "TodoQuickFix", "TodoLocList"}, dependencies = {"nvim-lua/plenary.nvim"}, opts = {}}
