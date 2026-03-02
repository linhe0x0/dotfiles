# Neovim Plugin Configuration Structure

This configuration follows a **hybrid strategy** combining functional grouping with single-plugin files for complex setups.

## Directory Structure

```
lua/plugins/
├── coding/              # Code editing and completion
│   ├── ai.lua          # Copilot + Sidekick
│   ├── completion.lua  # nvim-cmp + sources
│   ├── editing.lua     # mini.nvim, todo-comments, autotag
│   ├── formatting.lua  # conform.nvim
│   ├── linting.lua     # nvim-lint
│   └── snippets.lua    # LuaSnip + friendly-snippets
│
├── editor/              # Editor enhancements
│   ├── diagnostics.lua # trouble.nvim
│   ├── filetree.lua    # neo-tree + window-picker
│   ├── navigation.lua  # flash, illuminate, which-key
│   ├── telescope.lua   # telescope + file-browser
│   ├── tools.lua       # inc-rename, easy-align
│   └── treesitter.lua  # treesitter + textobjects + context
│
├── ui/                  # User interface
│   ├── breadcrumbs.lua # barbecue + navic
│   ├── bufferline.lua  # bufferline
│   ├── indent.lua      # indent-blankline
│   ├── misc.lua        # nui, devicons, dressing
│   ├── notify.lua      # noice + nvim-notify
│   └── statusline.lua  # lualine
│
├── tools/               # Utility tools
│   ├── git.lua         # gitsigns + diffview
│   └── misc.lua        # snacks.nvim
│
├── colorscheme.lua      # Color scheme
└── lsp.lua              # LSP configuration
```

## Organization Principles

### Independent Files (Complex/Important Plugins)
- `lsp.lua` - LSP configuration (complex setup)
- `colorscheme.lua` - Color scheme configuration

### Functional Grouping (Related Plugins)
Plugins are grouped by functionality in subdirectories:

- **coding/**: All code editing, completion, and AI-related plugins
- **editor/**: Editor enhancement features like navigation, search, diagnostics
- **ui/**: User interface components (statusline, bufferline, notifications)
- **tools/**: Utility tools like git integration

## Benefits

1. **Clear separation of concerns** - Each category has its own directory
2. **Easy navigation** - Related plugins are grouped together
3. **Maintainable** - No single file is too large (previously 652 lines → now ~100-200 lines per file)
4. **Scalable** - Easy to add new plugins to the appropriate category
5. **Fast lookup** - Know exactly where to find a specific feature

## Migration Notes

Previous structure had 6 files with some very large files:
- `editor.lua` (652 lines) → split into 6 files
- `coding.lua` (470 lines) → split into 6 files
- `ui.lua` (354 lines) → split into 6 files
- `tools.lua` (30 lines) → split into 2 files

Current structure: **22 files** organized in **4 subdirectories** + 2 root-level files
