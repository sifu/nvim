{1 "https://github.com/gbprod/substitute.nvim"
 :keys [{1 "<leader>r"
         2 (fn []
             (let [s (require "substitute")] (s.operator)))}
        {1 "<leader>rr"
         2 (fn []
             (let [s (require "substitute")] (s.line)))}
        {1 "<leader>R"
         2 (fn []
             (let [s (require "substitute")] (s.eol)))}
        {1 "<leader>r"
         2 (fn []
             (let [s (require "substitute")] (s.eol)))
         :mode "v"}]}
