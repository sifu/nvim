# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration written in Fennel, a Lisp-like language that compiles to Lua. The configuration uses:

- **Plugin Manager**: Lazy.nvim for plugin management
- **Fennel Compilation**: NFNL (Neovim Fennel Lua) for compiling .fnl files to Lua
- **Leader Key**: `€` (Euro symbol) is used as the leader key
- **Package Management**: Mason for LSP server management

## Directory Structure

```
/Users/sifu/.config/nvim/
├── init.lua                 # Main entry point, bootstraps lazy.nvim
├── lua/plugins.lua         # Plugin specification for lazy.nvim
├── lazy-lock.json          # Locked plugin versions
├── fnl/                    # Fennel source files
│   ├── config/             # Core configuration modules
│   │   ├── init.fnl        # Main configuration and vim options
│   │   ├── lsp.fnl         # LSP configuration
│   │   └── ...
│   ├── plugins/            # Plugin configurations (one per file)
│   │   ├── lsp.fnl         # LSP setup with Mason
│   │   ├── telescope.fnl   # Telescope fuzzy finder
│   │   ├── format.fnl      # Code formatting with conform.nvim
│   │   └── ...
│   └── user/               # Custom utilities and functions
│       ├── timelog.fnl     # Time tracking utilities
│       └── ...
└── undodir/                # Persistent undo files
```

## Key Technologies

- **Language Servers**: TypeScript (vtsls), Fennel, CSS, Tailwind CSS, Clojure LSP
- **Formatters**: Prettier/Prettierd for JS/TS, Stylua for Lua, fnlfmt for Fennel
- **Core Plugins**: 
  - Telescope for fuzzy finding
  - LSP with Mason for language server management
  - Conform.nvim for formatting
  - Conjure for Clojure/Fennel REPL
  - Oil.nvim for file management
  - Treesitter for syntax highlighting

## Common Development Tasks

### Code Formatting
Formatting is handled by conform.nvim and runs automatically on save:
- JavaScript/TypeScript: Uses prettierd → prettier (fallback)
- Fennel: Uses fnlfmt
- Lua: Uses stylua
- JSON: Uses fixjson

### LSP Management
Language servers are managed by Mason and configured in `fnl/plugins/lsp.fnl`:
- TypeScript: vtsls with enhanced settings for imports and inlay hints
- Fennel: fennel_language_server with vim globals
- CSS: cssls and cssmodules_ls
- Tailwind CSS: tailwindcss
- Clojure: clojure_lsp

### Plugin Management
Plugins are defined in Fennel files under `fnl/plugins/` and loaded via lazy.nvim.

### Custom Utilities
User-defined functions are in `fnl/user/`:
- `timelog.fnl`: Time tracking functionality
- `html-to-jsx.fnl`: HTML to JSX conversion
- `follow-redirect.fnl`: URL redirect following

## Important Notes

- The configuration is compiled from Fennel to Lua using NFNL
- Persistent undo is enabled with files stored in `undodir/`
- The leader key is `€` (Euro symbol) - ensure this is properly handled in text processing
- TypeScript files (.ts) are treated as TypeScript React by default
- Text width is set to 100 characters
- Uses light background theme by default