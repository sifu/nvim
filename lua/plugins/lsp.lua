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
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()
  return mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "tailwindcss", "clojure_lsp"}}, lspconfig.fennel_language_server.setup({capabilities = capabilities, settings = {fennel = {diagnostics = {globals = {"vim"}}}}}), lspconfig.vtsls.setup({capabilities = capabilities}), lspconfig.cssmodules_ls.setup({capabilities = capabilities}), lspconfig.cssls.setup({capabilities = capabilities}), lspconfig.tailwindcss.setup({capabilities = capabilities}), lspconfig.clojure_lsp.setup({capabilities = capabilities}))
end
return {{"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim"}}, {"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp"}, config = _2_}}
