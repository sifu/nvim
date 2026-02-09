; FIXME: why is this not working?
; :opts {:keymaps {:smart_increment {:enabled true}}}}

{1 "luckasRanarison/tailwind-tools.nvim"
 :name "tailwind-tools"
 :build ":UpdateRemotePlugins"
 :dependencies ["nvim-treesitter/nvim-treesitter"]
 ;; Disable automatic LSP setup since we handle it in lsp.fnl
 :opts {:server {:override false}}}
