-- [nfnl] fnl/plugins/highlighted-yank.fnl
local function _1_()
  local function _2_()
    return vim.cmd("highlight! IncSearch cterm=reverse gui=reverse")
  end
  return vim.schedule(_2_)
end
return {"machakann/vim-highlightedyank", event = "VeryLazy", config = _1_}
