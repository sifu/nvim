-- [nfnl] fnl/plugins/lsp.fnl
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
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
local vtsls_opts = {capabilities = capabilities, settings = {complete_function_calls = true, vtsls = {enableMoveToFileCodeAction = true}, typescript = {preferences = {importModuleSpecifier = "non-relative", importModuleSpecifierEnding = "minimal"}, updateImportsOnFileMove = {enabled = "always"}}, suggest = {completeFunctionCalls = true}, inlayHints = {enumMemberValues = {enabled = true}, functionLikeReturnTypes = {enabled = true}, parameterNames = {enabled = "literals"}, parameterTypes = {enabled = true}, propertyDeclarationTypes = {enabled = true}, variableTypes = {enabled = false}}}}
local cssls_opts = {capabilities = capabilities, settings = {css = {validate = true, lint = {unknownAtRules = "ignore"}}}}
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "tailwindcss", "clojure_lsp"}})
  vim.lsp.config("fennel_language_server", {capabilities = capabilities, settings = {fennel = {diagnostics = {globals = {"vim"}}}}})
  vim.lsp.enable("fennel_language_server")
  vim.lsp.config("vtsls", vtsls_opts)
  vim.lsp.enable("vtsls")
  vim.lsp.config("cssmodules_ls", {capabilities = capabilities})
  vim.lsp.enable("cssmodules_ls")
  vim.lsp.config("cssls", cssls_opts)
  vim.lsp.enable("cssls")
  vim.lsp.config("tailwindcss", {capabilities = capabilities})
  vim.lsp.enable("tailwindcss")
  vim.lsp.config("clojure_lsp", {capabilities = capabilities})
  return vim.lsp.enable("clojure_lsp")
end
return {{"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim"}}, {"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp"}, config = _2_}}
