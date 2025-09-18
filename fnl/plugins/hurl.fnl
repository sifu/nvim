; {1 "jellydn/hurl.nvim"
;  :dependencies ["MunifTanjim/nui.nvim"
;                 "nvim-lua/plenary.nvim"
;                 "nvim-treesitter/nvim-treesitter"]
;  :ft "hurl"
;  :opts {:debug false
;         ;; Show notification on run
;         :show_notification false
;         ;; Show response in popup or split
;         :mode "split"
;         ;; Default formatter
;         :formatters {:json ["jq"]
;                      :html ["prettier" "--parser" "html"]
;                      :xml ["tidy" "-xml" "-i" "-q"]}
;         :mappings {:close "q" :next_panel "<C-n>" :prev_panel "<C-p>"}}
;  :keys [{1 "<leader>hA" 2 "<cmd>HurlRunner<cr>" :desc "Run All Requests"}
;         {1 "<leader>ha" 2 "<cmd>HurlRunnerAt<cr>" :desc "Run Api Request"}
;         {1 "<leader>hl"
;          2 "<cmd>HurlShowLastResponse<cr>"
;          :desc "Show Last Response"}
;         {1 "<leader>hr" 2 "<cmd>HurlRerun<cr>" :desc "Rerun last Api Request"}
;         {1 "<leader>hte"
;          2 "<cmd>HurlRunnerToEntry<cr>"
;          :desc "Run Api request to entry"}
;         {1 "<leader>htE"
;          2 "<cmd>HurlRunnerToEnd<cr>"
;          :desc "Run Api request from current entry to end"}
;         {1 "<leader>htm" 2 "<cmd>HurlToggleMode<CR>" :desc "Hurl Toggle Mode"}
;         {1 "<leader>htv"
;          2 "<cmd>HurlVerbose<cr>"
;          :desc "Run Api in verbose mode"}
;         {1 "<leader>htV"
;          2 "<cmd>HurlVeryVerbose<cr>"
;          :desc "Run Api in very verbose mode"}
;         {1 "<leader>hh" 2 ":HurlRunner<CR>" :desc "Hurl Runner" :mode "v"}]}

;; TODO: use https://github.com/mistweaverco/kulala.nvim instead
{}
