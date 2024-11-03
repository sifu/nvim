{1 "chrisgrieser/nvim-various-textobjs"
 :event "UIEnter"
 :config (fn []
           (let [textobjs (require "various-textobjs")]
             (textobjs.setup {:useDefaultKeymaps true :disabledKeymaps ["gc"]})))}
