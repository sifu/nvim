(local {: autoload} (require "nfnl.module"))
(local str (autoload "nfnl.string"))

(fn kebab->camel [s]
  (string.gsub s "-%a+"
               (fn [word]
                 (let [first (string.sub word 2 2)
                       rest (string.sub word 3)]
                   (.. (string.upper first) rest)))))

(fn class->className [s] (string.gsub s "class=" "className="))

(fn remove-comments [s] (string.gsub s "<!%-%- .* %-%->" ""))

(fn html->jsx [html]
  (->> html
       class->className
       kebab->camel
       remove-comments))

(vim.api.nvim_create_user_command "ToJsx"
                                  (fn [args]
                                    (let [html (str.join "\n"
                                                         (vim.api.nvim_buf_get_lines 0
                                                                                     (- args.line1
                                                                                        1)
                                                                                     args.line2
                                                                                     true))
                                          jsx (html->jsx html)]
                                      (vim.api.nvim_buf_set_lines 0
                                                                  (- args.line1
                                                                     1)
                                                                  args.line2
                                                                  true
                                                                  (str.split jsx
                                                                             "\n"))))
                                  {:range true})
