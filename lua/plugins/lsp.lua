-- [nfnl] fnl/plugins/lsp.fnl
vim.diagnostic.config({signs = {text = {[vim.diagnostic.severity.ERROR] = "", [vim.diagnostic.severity.WARN] = "", [vim.diagnostic.severity.INFO] = "", [vim.diagnostic.severity.HINT] = ""}}})
local vtsls_settings = {complete_function_calls = true, vtsls = {enableMoveToFileCodeAction = true}, typescript = {preferences = {importModuleSpecifier = "non-relative", importModuleSpecifierEnding = "minimal"}, updateImportsOnFileMove = {enabled = "always"}}, suggest = {completeFunctionCalls = true}, inlayHints = {enumMemberValues = {enabled = true}, functionLikeReturnTypes = {enabled = true}, parameterNames = {enabled = "literals"}, parameterTypes = {enabled = true}, propertyDeclarationTypes = {enabled = true}, variableTypes = {enabled = false}}}
local cssls_settings = {css = {validate = true, lint = {unknownAtRules = "ignore"}}}
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  return mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "html", "eslint", "tailwindcss", "clojure_lsp"}})
end
local function _3_()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()
  vim.lsp.config("fennel_language_server", {capabilities = capabilities, settings = {fennel = {diagnostics = {globals = {"vim"}}}}})
  vim.lsp.config("vtsls", {capabilities = capabilities, settings = vtsls_settings})
  vim.lsp.config("cssmodules_ls", {capabilities = capabilities})
  vim.lsp.config("cssls", {capabilities = capabilities, settings = cssls_settings})
  vim.lsp.config("tailwindcss", {capabilities = capabilities})
  vim.lsp.config("html", {capabilities = capabilities})
  vim.lsp.config("eslint", {capabilities = capabilities})
  vim.lsp.config("clojure_lsp", {capabilities = capabilities})
  return vim.lsp.enable({"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "tailwindcss", "html", "eslint", "clojure_lsp"})
end
return {{"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, config = _2_}, {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp"}, config = _3_}}
