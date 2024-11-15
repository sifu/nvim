{1 "johmsalas/text-case.nvim"
 :dependencies ["nvim-telescope/telescope.nvim"]
 :config (fn []
           (let [textcase (require "textcase")
                 telescope (require "telescope")]
             (textcase.setup)
             (telescope.load_extension "textcase")))
 :keys [{1 "gaa"
         2 "<cmd>TextCaseOpenTelescope<cr>"
         :mode ["n" "x"]
         :desc "Change Text Case"}
        {1 "gau"
         2 ":lua require('textcase').current_word('to_upper_case')<CR>"
         :mode ["n" "x"]
         :desc "UPPER CASE"}
        {1 "gal"
         2 ":lua require('textcase').current_word('to_lower_case')<CR>"
         :mode ["n" "x"]
         :desc "lower case"}
        {1 "gas"
         2 ":lua require('textcase').current_word('to_snake_case')<CR>"
         :mode ["n" "x"]
         :desc "snake_case"}
        {1 "gad"
         2 ":lua require('textcase').current_word('to_dash_case')<CR>"
         :mode ["n" "x"]
         :desc "dash-case"}
        {1 "gan"
         2 ":lua require('textcase').current_word('to_constant_case')<CR>"
         :mode ["n" "x"]
         :desc "CONSTANT_CASE"}
        {1 "ga."
         2 ":lua require('textcase').current_word('to_dot_case')<CR>"
         :mode ["n" "x"]
         :desc "dot.case"}
        {1 "ga,"
         2 ":lua require('textcase').current_word('to_comma_case')<CR>"
         :mode ["n" "x"]
         :desc "comma,case"}
        {1 "gac"
         2 ":lua require('textcase').current_word('to_camel_case')<CR>"
         :mode ["n" "x"]
         :desc "camelCase"}
        {1 "gap"
         2 ":lua require('textcase').current_word('to_pascal_case')<CR>"
         :mode ["n" "x"]
         :desc "PascalCase"}
        {1 "gat"
         2 ":lua require('textcase').current_word('to_title_case')<CR>"
         :mode ["n" "x"]
         :desc "Title Case"}
        {1 "gaf"
         2 ":lua require('textcase').current_word('to_path_case')<CR>"
         :mode ["n" "x"]
         :desc "path/case"}]}
