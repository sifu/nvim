-- [nfnl] Compiled from fnl/config/keymaps.fnl by https://github.com/Olical/nfnl, do not edit.
local normal_mode_mappings = {{key = "<Tab>", map = ":bn<cr>", desc = "Next Buffer"}, {key = "<s-Tab>", map = ":bp<cr>", desc = "Previous Buffer"}, {key = "U", map = ":redo<cr>", desc = "Redo"}, {key = "gf", map = ":e <cfile><cr>", desc = "Open file under cursor"}, {key = ",,", map = ":e#<cr>", desc = "Switch between alternate buffers"}, {key = "<leader>w", map = "<C-w>", desc = "Window movements"}, {key = "\203\153", map = "<C-W><C-H>", desc = "Window movements"}, {key = "\194\172", map = "<C-W><C-L>", desc = "Window movements"}, {key = "\226\136\134", map = "<C-W><C-J>", desc = "Window movements"}, {key = "\203\154", map = "<C-W><C-K>", desc = "Window movements"}, {key = "\195\184", map = "<C-W><C-O>", desc = "Window movements"}, {key = "\195\159", map = "<C-W><C-S>", desc = "Window movements"}, {key = "\226\136\154", map = "<C-W><C-V>", desc = "Window movements"}}
for _, entry in ipairs(normal_mode_mappings) do
  vim.keymap.set("n", entry.key, entry.map, {noremap = true, desc = entry.desc})
end
return nil
