-- [nfnl] Compiled from fnl/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "clojure_lsp"}})
  lspconfig.fennel_language_server.setup({settings = {fennel = {diagnostics = {globals = {"vim"}}}}})
  return lspconfig.clojure_lsp.setup({})
end
return {{"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim"}}, {"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, config = _2_}}
