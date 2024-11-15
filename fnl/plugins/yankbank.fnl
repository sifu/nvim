{1 "ptdewey/yankbank-nvim"
 :cmd "YankBank"
 :dependencies "kkharji/sqlite.lua"
 :config (fn []
           (let [yb (require "yankbank")]
             (yb.setup {:num_behavior "jump" :persist_type "sqlite"})))}
