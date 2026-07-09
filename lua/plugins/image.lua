-- [nfnl] fnl/plugins/image.fnl
local vault_assets = vim.fn.expand("~/Obsidian/Main/assets")
local function file_exists_3f(path)
  return (path and (nil ~= vim.uv.fs_stat(path)))
end
local function resolve_image_path(document_path, image_path, fallback)
  local default = fallback(document_path, image_path)
  if file_exists_3f(default) then
    return default
  else
    local name = vim.fn.fnamemodify(image_path, ":t")
    local in_assets = (vault_assets .. "/" .. name)
    if file_exists_3f(in_assets) then
      return in_assets
    else
      return default
    end
  end
end
return {"3rd/image.nvim", ft = {"markdown"}, opts = {backend = "kitty", processor = "magick_cli", integrations = {markdown = {enabled = true, download_remote_images = true, filetypes = {"markdown"}, resolve_image_path = resolve_image_path, clear_in_insert_mode = false, only_render_image_at_cursor = false}, asciidoc = {enabled = false}, neorg = {enabled = false}, rst = {enabled = false}, typst = {enabled = false}, html = {enabled = false}, css = {enabled = false}}, max_height_window_percentage = 50, window_overlap_clear_enabled = true, tmux_show_only_in_active_window = true}}
