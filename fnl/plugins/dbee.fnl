{1 "kndndrj/nvim-dbee"
 :cmd "Dbee"
 :dependencies ["MunifTanjim/nui.nvim"]
 :build (fn []
          (let [dbee (require "dbee")] (dbee.install "go")))
 :config true}
