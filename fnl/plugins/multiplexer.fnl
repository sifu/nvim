; vim.keymap.set('n', '<C-S-h>', multiplexer.resize_pane_left, { desc = 'Resize pane to the left'})
; vim.keymap.set('n', '<C-S-j>', multiplexer.resize_pane_down, { desc = 'Resize pane below'})
; vim.keymap.set('n', '<C-S-k>', multiplexer.resize_pane_up, { desc = 'Resize pane above'})
; vim.keymap.set('n', '<C-S-l>', multiplexer.resize_pane_right, { desc = 'Resize pane to the right'})

; {1 "stevalkr/multiplexer.nvim"
;  :lazy false
;  :opts {:on_init (fn []
;                    (let [multiplexer (require "multiplexer")
;                          km vim.keymap.set]
;                      (km "n" "˙" multiplexer.activate_pane_left)
;                      (km "n" "∆" multiplexer.activate_pane_down)
;                      (km "n" "˚" multiplexer.activate_pane_up)
;                      (km "n" "¬" multiplexer.activate_pane_right)))}}

; TODO: try multiplexing again
{}
