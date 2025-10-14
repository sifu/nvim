-- [nfnl] fnl/config/lsp.fnl
local lsp_augroup = vim.api.nvim_create_augroup("LspConfig", {clear = true})
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
  local root_dir = find_root({".git", "fnl"})
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({bufnr = bufnr, name = "fennel_language_server"})
  if (#clients == 0) then
    return vim.lsp.start({name = "fennel_language_server", cmd = {"fennel-language-server"}, root_dir = root_dir, capabilities = capabilities, settings = fennel_settings})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {group = lsp_augroup, pattern = "fennel", callback = _2_})
local function _4_()
  local root_dir = find_root({".git", "package.json", "tsconfig.json"})
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({name = "vtsls"})
  local find_matching_client
  local function _5_(client_list)
    local found = nil
    for _, client in ipairs(client_list) do
      if found then break end
      if (client.root_dir == root_dir) then
        found = client
      else
      end
    end
    return found
  end
  find_matching_client = _5_
  local existing_client = find_matching_client(clients)
  if not existing_client then
    local function _7_(code, signal, client_id)
      return vim.notify(("vtsls exited with code: " .. (code or "nil") .. ", signal: " .. (signal or "nil")), vim.log.levels.ERROR)
    end
    return vim.lsp.start({name = "vtsls", cmd = {"vtsls", "--stdio"}, root_dir = root_dir, capabilities = capabilities, settings = vtsls_settings, on_exit = _7_})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {group = lsp_augroup, pattern = {"typescript", "javascript", "typescriptreact", "javascriptreact"}, callback = _4_})
local function _9_()
  local root_dir = find_root({".git", "package.json"})
  local bufnr = vim.api.nvim_get_current_buf()
  local cssls_clients = vim.lsp.get_clients({bufnr = bufnr, name = "cssls"})
  local cssmodules_clients = vim.lsp.get_clients({bufnr = bufnr, name = "cssmodules_ls"})
  local tailwind_clients = vim.lsp.get_clients({bufnr = bufnr, name = "tailwindcss"})
  if (#cssls_clients == 0) then
    vim.lsp.start({name = "cssls", cmd = {"vscode-css-language-server", "--stdio"}, root_dir = root_dir, capabilities = capabilities, settings = cssls_settings})
  else
  end
  if (#cssmodules_clients == 0) then
    vim.lsp.start({name = "cssmodules_ls", cmd = {"cssmodules-language-server"}, root_dir = root_dir, capabilities = capabilities})
  else
  end
  if (#tailwind_clients == 0) then
    return vim.lsp.start({name = "tailwindcss", cmd = {"tailwindcss-language-server", "--stdio"}, root_dir = find_root({".git", "package.json", "tailwind.config.js", "tailwind.config.ts"}), capabilities = capabilities})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {group = lsp_augroup, pattern = "css", callback = _9_})
local function _13_()
  local root_dir = find_root({".git", "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn"})
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({bufnr = bufnr, name = "clojure_lsp"})
  if (#clients == 0) then
    return vim.lsp.start({name = "clojure_lsp", cmd = {"clojure-lsp"}, root_dir = root_dir, capabilities = capabilities})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {group = lsp_augroup, pattern = {"clojure", "edn"}, callback = _13_})
return {}
