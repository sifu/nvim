-- [nfnl] Compiled from fnl/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local cmp_src_menu_items = {buffer = "buff", conjure = "conj", nvim_lsp = "lsp", luasnip = "lsnp"}
local cmp_srcs = {{name = "nvim_lsp"}, {name = "nvim_lsp_signature_help"}, {name = "conjure"}, {name = "codeium"}, {name = "path"}, {name = "buffer"}, {name = "luasnip"}}
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return ((col ~= 0) and (vim.api.nvim_buf_get_lines(0, (line - 1), line, true)[1]:sub(col, col):match("%s") == nil))
end
local function _1_()
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")
  local function _2_(fallback)
    if cmp.visible() then
      return cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      return luasnip.expand_or_jump()
    elseif has_words_before() then
      return cmp.complete()
    elseif "else" then
      return fallback()
    else
      return nil
    end
  end
  local function _4_(fallback)
    if cmp.visible() then
      return cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      return luasnip.jump(-1)
    elseif "else" then
      return fallback()
    else
      return nil
    end
  end
  local function _6_(args)
    return luasnip.lsp_expand(args.body)
  end
  cmp.setup({formatting = {format = lspkind.cmp_format({mode = "symbol_text", maxwidth = 120, ellipsis_char = "...", symbol_map = {Codeium = "\239\131\144"}})}, window = {completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered()}, mapping = {["<Up>"] = cmp.mapping.select_prev_item(), ["<Down>"] = cmp.mapping.select_next_item(), ["<C-b>"] = cmp.mapping.scroll_docs(( - 4)), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.confirm({select = true}), ["<C-e>"] = cmp.mapping.close(), ["<Tab>"] = cmp.mapping(_2_, {"i", "s"}), ["<S-Tab>"] = cmp.mapping(_4_, {"i", "s"})}, snippet = {expand = _6_}, sources = cmp_srcs})
  cmp.setup.filetype("oil", {enabled = false})
  return cmp.setup.filetype("chatgpt-input", {enabled = false})
end
return {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp-signature-help", "PaterJason/cmp-conjure", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim"}, config = _1_}
