-- [nfnl] Compiled from fnl/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local function define_signs(prefix)
  local error = (prefix .. "SignError")
  local warn = (prefix .. "SignWarn")
  local info = (prefix .. "SignInfo")
  local hint = (prefix .. "SignHint")
  vim.fn.sign_define(error, {text = "\239\129\151", texthl = error})
  vim.fn.sign_define(warn, {text = "\239\129\177", texthl = warn})
  vim.fn.sign_define(info, {text = "\239\129\154", texthl = info})
  return vim.fn.sign_define(hint, {text = "\239\129\153", texthl = hint})
end
define_signs("Diagnostic")
local fennel_opts = {settings = {fennel = {diagnostics = {globals = {"vim"}}}}}
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  return mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "ts_ls", "cssmodules_ls", "cssls", "clojure_lsp"}}, lspconfig.fennel_language_server.setup(fennel_opts), lspconfig.ts_ls.setup({init_options = {preferences = {importModuleSpecifierPreference = "non-relative"}}}), lspconfig.cssmodules_ls.setup({}), lspconfig.cssls.setup({}), lspconfig.clojure_lsp.setup({}))
end
return {{"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim"}}, {"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, config = _2_}}
