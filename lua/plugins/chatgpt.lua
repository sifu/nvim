-- [nfnl] Compiled from fnl/plugins/chatgpt.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local chatgpt = require("chatgpt")
  return chatgpt.setup({openai_params = {model = "gpt-4o"}, chat = {keymaps = {close = "<C-c>"}, yank_last_code = "<C-k>", yank_last = "<C-l>", scroll_up = "<C-u>", scroll_down = "<C-d>", toggle_settings = "<C-o>", new_session = "<C-n>", cycle_windows = "<Tab>"}, popup_input = {submit = "<C-s>"}})
end
return {"jackMort/ChatGPT.nvim", dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"}, keys = {{"<leader>acc", "<cmd>ChatGPT<CR>", desc = "ChatGPT", mode = {"n"}}, {"<leader>aca", "<cmd>ChatGPTActAs<cr>", desc = "Act as"}, {"<leader>ace", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = {"n", "v"}}, {"<leader>acg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = {"n", "v"}}, {"<leader>acT", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = {"n", "v"}}, {"<leader>ack", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = {"n", "v"}}, {"<leader>acd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = {"n", "v"}}, {"<leader>act", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = {"n", "v"}}, {"<leader>aco", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = {"n", "v"}}, {"<leader>acs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = {"n", "v"}}, {"<leader>acf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = {"n", "v"}}, {"<leader>acx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = {"n", "v"}}, {"<leader>acr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = {"n", "v"}}, {"<leader>acl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = {"n", "v"}}}, config = _1_}
