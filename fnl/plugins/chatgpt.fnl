{1 "jackMort/ChatGPT.nvim"
 :dependencies ["MunifTanjim/nui.nvim"
                "nvim-lua/plenary.nvim"
                "nvim-telescope/telescope.nvim"]
 :keys [{1 "<leader>ac" 2 "<cmd>ChatGPT<CR>" :desc "ChatGPT" :mode ["n"]}
        {1 "<leader>aa" 2 "<cmd>ChatGPTActAs<cr>" :desc "Act as"}
        {1 "<leader>ae"
         2 "<cmd>ChatGPTEditWithInstruction<CR>"
         :desc "Edit with instruction"
         :mode ["n" "v"]}
        {1 "<leader>ag"
         2 "<cmd>ChatGPTRun grammar_correction<CR>"
         :desc "Grammar Correction"
         :mode ["n" "v"]}
        {1 "<leader>aT"
         2 "<cmd>ChatGPTRun translate<CR>"
         :desc "Translate"
         :mode ["n" "v"]}
        {1 "<leader>ak"
         2 "<cmd>ChatGPTRun keywords<CR>"
         :desc "Keywords"
         :mode ["n" "v"]}
        {1 "<leader>ad"
         2 "<cmd>ChatGPTRun docstring<CR>"
         :desc "Docstring"
         :mode ["n" "v"]}
        {1 "<leader>at"
         2 "<cmd>ChatGPTRun add_tests<CR>"
         :desc "Add Tests"
         :mode ["n" "v"]}
        {1 "<leader>ao"
         2 "<cmd>ChatGPTRun optimize_code<CR>"
         :desc "Optimize Code"
         :mode ["n" "v"]}
        {1 "<leader>as"
         2 "<cmd>ChatGPTRun summarize<CR>"
         :desc "Summarize"
         :mode ["n" "v"]}
        {1 "<leader>af"
         2 "<cmd>ChatGPTRun fix_bugs<CR>"
         :desc "Fix Bugs"
         :mode ["n" "v"]}
        {1 "<leader>ax"
         2 "<cmd>ChatGPTRun explain_code<CR>"
         :desc "Explain Code"
         :mode ["n" "v"]}
        {1 "<leader>ar"
         2 "<cmd>ChatGPTRun roxygen_edit<CR>"
         :desc "Roxygen Edit"
         :mode ["n" "v"]}
        {1 "<leader>al"
         2 "<cmd>ChatGPTRun code_readability_analysis<CR>"
         :desc "Code Readability Analysis"
         :mode ["n" "v"]}]
 :config (fn []
           (let [chatgpt (require "chatgpt")]
             (chatgpt.setup {:openai_params {:model "gpt-4o"}
                             :chat {:keymaps {:close "<C-c>"}
                                    :yank_last_code "<C-k>"
                                    :yank_last "<C-l>"
                                    :scroll_up "<C-u>"
                                    :scroll_down "<C-d>"
                                    :toggle_settings "<C-o>"
                                    :new_session "<C-n>"
                                    :cycle_windows "<Tab>"}
                             :popup_input {:submit "<C-s>"}})))}
