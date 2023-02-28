# NeoVim Config

## Plugin Manager

[lazy.nvim](https://github.com/folke/lazy.nvim)

## File Explorer

[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)

## Color Scheme
[OneDark](https://github.com/navarasu/onedark.nvim')

## Markdown

[MarkdownPreview](https://github.com/iamcco/markdown-preview.nvim))

## LSP

1. Create a single on_attach for all servers
2. Create individual 'settings' files for each language server
3. Dynamically load the settings when running setup on lspconfig for server


 -- Lua
 Settings are loaded from lua.lsp_settings.lua_ls
 This loads the paths where lua has access to the neovim code, the lua code in installed libs etc for lsp completion

 It's important to load the default lsp capabilities from vim.lsp.protocol.make_default_capabilities() to get neovim-lua completion

 -- Solargraph
 No settings file for this. Config is set via the .solargraph.json file per repo

## Git

[Fugitive](https://github.com/tpope/vim-fugitive)
[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)

### LSP Installer

[mason.nvim](https://github.com/williamboman/mason.nvim)
