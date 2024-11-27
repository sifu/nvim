;; XXX: If I try to use the same snippets in javascript and javascriptreact I get a strage error, so for
;; now I just will cast the javascriptreact files to javascript
(vim.filetype.add {:extension {:jsx "javascript"}})
