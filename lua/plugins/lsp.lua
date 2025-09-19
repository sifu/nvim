-- [nfnl] fnl/plugins/lsp.fnl
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
local function _1_()
  local mason = require("mason")
  return mason.setup()
end
local function _2_()
  local mason_lspconfig = require("mason-lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()
  mason_lspconfig.setup({ensure_installed = {"fennel_language_server", "vtsls", "cssmodules_ls", "cssls", "tailwindcss", "clojure_lsp"}, automatic_enable = false})
  vim.lsp.config("fennel_language_server", {capabilities = capabilities, settings = {fennel = {diagnostics = {globals = {"vim"}}}}})
  vim.lsp.config("vtsls", {capabilities = capabilities, settings = {complete_function_calls = true, vtsls = {enableMoveToFileCodeAction = true}, typescript = {preferences = {importModuleSpecifier = "non-relative", importModuleSpecifierEnding = "minimal"}, updateImportsOnFileMove = {enabled = "always"}}, suggest = {completeFunctionCalls = true}, inlayHints = {enumMemberValues = {enabled = true}, functionLikeReturnTypes = {enabled = true}, parameterNames = {enabled = "literals"}, parameterTypes = {enabled = true}, propertyDeclarationTypes = {enabled = true}, variableTypes = {enabled = false}}}})
  vim.lsp.config("cssmodules_ls", {capabilities = capabilities})
  vim.lsp.config("cssls", {capabilities = capabilities, settings = {css = {validate = true, lint = {unknownAtRules = "ignore"}}}})
  vim.lsp.config("tailwindcss", {capabilities = capabilities})
  vim.lsp.config("clojure_lsp", {capabilities = capabilities})
  vim.lsp.enable("fennel_language_server")
  vim.lsp.enable("vtsls")
  vim.lsp.enable("cssmodules_ls")
  vim.lsp.enable("cssls")
  vim.lsp.enable("tailwindcss")
  vim.lsp.enable("clojure_lsp")
  local server_configs = {fennel_language_server = {filetypes = {"fennel"}, cmd = {"fennel-language-server"}, settings = {fennel = {diagnostics = {globals = {"vim"}}}}}, vtsls = {filetypes = {"typescript", "javascript", "typescriptreact", "javascriptreact"}, cmd = {"vtsls", "--stdio"}, settings = {complete_function_calls = true}, vtsls = {enableMoveToFileCodeAction = true}, typescript = {preferences = {importModuleSpecifier = "non-relative", importModuleSpecifierEnding = "minimal"}, updateImportsOnFileMove = {enabled = "always"}}, suggest = {completeFunctionCalls = true}, inlayHints = {enumMemberValues = {enabled = true}, functionLikeReturnTypes = {enabled = true}, parameterNames = {enabled = "literals"}, parameterTypes = {enabled = true}, propertyDeclarationTypes = {enabled = true}, variableTypes = {enabled = false}}}, cssls = {filetypes = {"css", "scss", "less"}, cmd = {"vscode-css-language-server", "--stdio"}, settings = {css = {validate = true}, lint = {unknownAtRules = "ignore"}}}, cssmodules_ls = {filetypes = {"typescript", "javascript", "typescriptreact", "javascriptreact"}, cmd = {"cssmodules-language-server"}}, tailwindcss = {filetypes = {"html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte"}, cmd = {"tailwindcss-language-server", "--stdio"}}, clojure_lsp = {filetypes = {"clojure", "clojurescript", "edn"}, cmd = {"clojure-lsp"}}}
  for server_name, config in pairs(server_configs) do
    local function _3_()
      local server_config = vim.tbl_deep_extend("force", {name = server_name, capabilities = capabilities}, config)
      return vim.lsp.start(server_config)
    end
    vim.api.nvim_create_autocmd("FileType", {pattern = config.filetypes, callback = _3_})
  end
  return nil
end
return {{"williamboman/mason.nvim", config = _1_}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp"}, config = _2_}}
