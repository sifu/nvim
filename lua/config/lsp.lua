-- [nfnl] fnl/config/lsp.fnl
local function define_signs(prefix)
  local error = (prefix .. "SignError")
  local warn = (prefix .. "SignWarn")
  local info = (prefix .. "SignInfo")
  local hint = (prefix .. "SignHint")
  vim.fn.sign_define(error, {text = "", texthl = error})
  vim.fn.sign_define(warn, {text = "", texthl = warn})
  vim.fn.sign_define(info, {text = "", texthl = info})
  return vim.fn.sign_define(hint, {text = "", texthl = hint})
end
define_signs("Diagnostic")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
local function find_root(markers)
  local bufpath = vim.api.nvim_buf_get_name(0)
  local found = vim.fs.find(markers, {upward = true, path = bufpath})
  if (#found > 0) then
    return vim.fs.dirname(found[1])
  else
    return vim.fs.dirname(bufpath)
  end
end
local vtsls_settings = {complete_function_calls = true, vtsls = {enableMoveToFileCodeAction = true}, typescript = {preferences = {importModuleSpecifier = "non-relative", importModuleSpecifierEnding = "minimal"}, updateImportsOnFileMove = {enabled = "always"}}, suggest = {completeFunctionCalls = true}, inlayHints = {enumMemberValues = {enabled = true}, functionLikeReturnTypes = {enabled = true}, parameterNames = {enabled = "literals"}, parameterTypes = {enabled = true}, propertyDeclarationTypes = {enabled = true}, variableTypes = {enabled = false}}}
local cssls_settings = {css = {validate = true, lint = {unknownAtRules = "ignore"}}}
local fennel_settings = {fennel = {diagnostics = {globals = {"vim"}}}}
local function _2_()
  return vim.lsp.start({name = "fennel_language_server", cmd = {"fennel-language-server"}, root_dir = find_root({".git", "fnl"}), capabilities = capabilities, settings = fennel_settings})
end
vim.api.nvim_create_autocmd("FileType", {pattern = "fennel", callback = _2_})
local function _3_()
  return vim.lsp.start({name = "vtsls", cmd = {"vtsls", "--stdio"}, root_dir = find_root({".git", "package.json", "tsconfig.json"}), capabilities = capabilities, settings = vtsls_settings})
end
vim.api.nvim_create_autocmd("FileType", {pattern = {"typescript", "javascript", "typescriptreact", "javascriptreact"}, callback = _3_})
local function _4_()
  vim.lsp.start({name = "cssls", cmd = {"vscode-css-language-server", "--stdio"}, root_dir = find_root({".git", "package.json"}), capabilities = capabilities, settings = cssls_settings})
  vim.lsp.start({name = "cssmodules_ls", cmd = {"cssmodules-language-server"}, root_dir = find_root({".git", "package.json"}), capabilities = capabilities})
  return vim.lsp.start({name = "tailwindcss", cmd = {"tailwindcss-language-server", "--stdio"}, root_dir = find_root({".git", "package.json", "tailwind.config.js", "tailwind.config.ts"}), capabilities = capabilities})
end
vim.api.nvim_create_autocmd("FileType", {pattern = "css", callback = _4_})
local function _5_()
  return vim.lsp.start({name = "clojure_lsp", cmd = {"clojure-lsp"}, root_dir = find_root({".git", "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn"}), capabilities = capabilities})
end
vim.api.nvim_create_autocmd("FileType", {pattern = {"clojure", "edn"}, callback = _5_})
return {}
