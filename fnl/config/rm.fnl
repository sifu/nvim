(vim.api.nvim_create_user_command "Rm" (fn [] (vim.cmd.Remove) (vim.cmd.bd)) {})
