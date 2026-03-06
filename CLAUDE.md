# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration written in Fennel, a Lisp-like language that compiles to Lua. The configuration uses:

- **Plugin Manager**: Lazy.nvim for plugin management
- **Fennel Compilation**: NFNL (Neovim Fennel Lua) for compiling .fnl files to Lua
- **Leader Key**: `€` (Euro symbol) is used as the leader key
- **Package Management**: Mason for LSP server management
- **Theme**: onenord.nvim (light mode)

## Directory Structure

```
/Users/sifu/.config/nvim/
├── init.lua                 # Entry point, bootstraps lazy.nvim, sets mapleader
├── lua/plugins.lua         # Plugin specification for lazy.nvim (loads nfnl + config)
├── lazy-lock.json          # Locked plugin versions
├── fnl/                    # Fennel source files (compiled to lua/ by nfnl)
│   ├── config/             # Core configuration modules
│   │   ├── init.fnl        # Main config, vim options, requires other config modules
│   │   ├── lsp.fnl         # LSP servers via vim.lsp.start() autocmds
│   │   └── ...
│   ├── plugins/            # Plugin configurations (one per file, lazy.nvim specs)
│   │   ├── lsp.fnl         # Mason + mason-lspconfig setup (ensure_installed + vim.lsp.config/enable)
│   │   ├── format.fnl      # Code formatting with conform.nvim
│   │   └── ...
│   └── user/               # Custom utilities and functions
│       ├── timelog.fnl             # Time tracking
│       ├── html-to-jsx.fnl        # HTML to JSX conversion
│       ├── telescope-multigrep.fnl # Multi-grep telescope picker
│       ├── telescope-routes.fnl    # Route telescope picker
│       ├── code-action.fnl         # Custom code actions
│       ├── qf-improvements.fnl     # Quickfix list improvements
│       └── ...
└── /s/.config/nvim/undodir/ # Persistent undo files (symlinked path)
```

## Key Technologies

- **Language Servers**: vtsls (TypeScript), fennel_language_server, cssls, cssmodules_ls, tailwindcss, html, eslint, clojure_lsp
- **Formatters**: Prettierd/Prettier for JS/TS/CSS, Stylua for Lua, fnlfmt for Fennel, fixjson for JSON, sqruff for SQL
- **Core Plugins**: Telescope, Mason, Conform.nvim, Conjure, Oil.nvim, Treesitter, Neogit, Supermaven

## Common Development Tasks

### Adding a Plugin
1. Create a new `.fnl` file in `fnl/plugins/` returning a lazy.nvim plugin spec table
2. NFNL auto-compiles it to `lua/plugins/` — lazy.nvim picks it up automatically
3. Restart Neovim or run `:Lazy sync`

### Code Formatting
Formatting is handled by conform.nvim (`fnl/plugins/format.fnl`) and runs automatically on save:
- JavaScript/TypeScript/CSS: prettierd → prettier (fallback, `stop_after_first`)
- Fennel: fnlfmt
- Lua: stylua
- JSON: fixjson
- SQL: sqruff

### LSP Management
Language servers are managed by Mason and configured in `fnl/plugins/lsp.fnl`.

## Gotchas

- **Dual LSP config**: `fnl/plugins/lsp.fnl` uses mason-lspconfig with `vim.lsp.config()`/`vim.lsp.enable()`. `fnl/config/lsp.fnl` uses manual `vim.lsp.start()` autocmds. Both exist — check which one is active for a given server before editing
- **Undodir path**: Set to `/s/.config/nvim/undodir` (not the local `~/.config/nvim/undodir`)
- **Leader key**: `€` (Euro symbol) — ensure this is properly handled in text processing
- **TypeScript files** (.ts) are treated as TypeScript React by default
- **Text width**: 100 characters
- **Light background** theme (onenord) by default

## Important Notes

- Always remind me to save the file in Neovim when you make any changes
- The configuration is compiled from Fennel to Lua using NFNL — edit `.fnl` files, not the compiled `.lua` files
