-- [nfnl] fnl/plugins/img-clip.fnl
local image_exts = {png = true, jpg = true, jpeg = true, gif = true, webp = true, avif = true}
local vault = vim.fn.expand("~/Obsidian/Main")
local function assets_dir()
  if vim.startswith(vim.fn.expand("%:p"), vault) then
    return (vault .. "/assets")
  else
    return "assets"
  end
end
local function dropped_image_path(lines)
  local only = nil
  local n = 0
  for _, l in ipairs(lines) do
    if (vim.trim(l) ~= "") then
      n = (n + 1)
      only = l
    else
    end
  end
  if (n == 1) then
    local stripped = only:gsub("^file://", "")
    local path = vim.trim(stripped)
    local ext = string.lower(vim.fn.fnamemodify(path, ":e"))
    if (image_exts[ext] and (1 == vim.fn.filereadable(path))) then
      return path
    else
      return nil
    end
  else
    return nil
  end
end
local function embed_dropped_image(path)
  local function _5_()
    local img_clip = require("img-clip")
    return img_clip.paste_image({dir_path = assets_dir(), file_name = vim.fn.fnamemodify(path, ":t"), copy_images = true, template = "![[$FILE_NAME]]", insert_mode_after_paste = false, prompt_for_file_name = false}, path)
  end
  return vim.schedule(_5_)
end
local function install_paste_handler()
  if not vim.g.img_clip_paste_wrapped then
    vim.g.img_clip_paste_wrapped = true
    local orig = vim.paste
    local function _6_(lines, phase)
      local ok, path
      local function _7_()
        return ((vim.bo.filetype == "markdown") and dropped_image_path(lines))
      end
      ok, path = pcall(_7_)
      if (ok and path) then
        embed_dropped_image(path)
        return true
      else
        return orig(lines, phase)
      end
    end
    vim.paste = _6_
    return nil
  else
    return nil
  end
end
return {"HakonHarnes/img-clip.nvim", lazy = true, init = install_paste_handler, opts = {}}
