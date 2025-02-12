-- [nfnl] Compiled from fnl/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local cmp_srcs = {{name = "nvim_lsp"}, {name = "nvim_lsp_signature_help"}, {name = "conjure"}, {name = "render-markdown"}, {name = "path"}, {name = "luasnip"}}
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return ((col ~= 0) and (vim.api.nvim_buf_get_lines(0, (line - 1), line, true)[1]:sub(col, col):match("%s") == nil))
end
local function formatting(entry, vim_item)
  local completion_item = entry:get_completion_item()
  local colorful_menu = require("colorful-menu")
  local lspkind = require("lspkind")
  local highlights_info = colorful_menu.cmp_highlights(entry)
  if (highlights_info == nil) then
    vim_item.abbr = completion_item.label
  else
    vim_item.abbr_hl_group = highlights_info.highlights
    vim_item.abbr = highlights_info.text
  end
  local kind = lspkind.cmp_format({mode = "symbol_text"})(entry, vim_item)
  local strings = vim.split(kind.kind, "%s", {trimempty = true})
  local _3_
  do
    local t_2_ = strings
    if (nil ~= t_2_) then
      t_2_ = t_2_[1]
    else
    end
    _3_ = t_2_
  end
  vim_item.kind = (" " .. _3_ .. " ")
  vim_item.menu = ""
  return vim_item
end
local function _5_()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local function _6_()
    if cmp.visible() then
      return cmp.confirm({select = true})
    elseif "else" then
      return cmp.complete()
    else
      return nil
    end
  end
  local function _8_(fallback)
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
  local function _10_(args)
    return luasnip.lsp_expand(args.body)
  end
  cmp.setup({formatting = {format = formatting}, completion = {autocomplete = false}, window = {completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered()}, mapping = {["<Up>"] = cmp.mapping.select_prev_item(), ["<Down>"] = cmp.mapping.select_next_item(), ["<C-b>"] = cmp.mapping.scroll_docs(( - 4)), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping(_6_), ["<C-e>"] = cmp.mapping.close(), ["<S-Tab>"] = cmp.mapping(_8_, {"i", "s"})}, snippet = {expand = _10_}, sources = cmp_srcs})
  cmp.setup.filetype("oil", {enabled = false})
  cmp.setup.filetype("chatgpt-input", {enabled = false})
  cmp.setup.cmdline("/", {mapping = cmp.mapping.preset.cmdline(), sources = {{name = "buffer"}}})
  return cmp.setup.cmdline(":", {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = "path"}, {name = "cmdline", option = {ignore_cmds = {"!", "Man"}}}})})
end
return {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp-signature-help", "hrsh7th/cmp-cmdline", "PaterJason/cmp-conjure", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "MeanderingProgrammer/render-markdown.nvim", "xzbdmw/colorful-menu.nvim", "onsails/lspkind.nvim"}, config = _5_}
