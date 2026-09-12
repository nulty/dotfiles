# NeoVim Config

Requires Neovim 0.11+ (`setup.sh` pins the version it installs). The config is
symlinked to `/usr/local/.config/nvim`, so edits here take effect immediately.

## Layout

```
init.lua              leader, lazy.nvim bootstrap, :Browse for GBrowse
lua/mappings.lua      options, global keymaps, autocommands
lua/lsp_config.lua    shared LSP on_attach (keymaps, document highlight)
lua/formatting.lua    the format chain: :FormatInfo, :FormatOnSave, :FormatDebug
lua/plugins/*.lua     one file per feature area, loaded by lazy.nvim
after/lsp/*.lua       per-server settings, merged over the shared defaults
ftplugin/             per-filetype overrides
templates/            files :HerbInit and friends copy into a project
```

## LSP

Three pieces, in load order:

1. `vim.lsp.config('*', require('lsp_config'))` sets the shared defaults
   (capabilities) for every server.
2. `after/lsp/<server>.lua` is picked up by Neovim automatically and merged
   over those defaults. Add a server's settings by creating a file here.
3. Keymaps come from an `LspAttach` autocmd in `lua/lsp_config.lua`, *not* an
   `on_attach`. A server-level `on_attach` replaces the shared one rather than
   chaining, and nvim-lspconfig ships its own for eslint, stylelint_lsp and
   ~24 others, so keymaps set that way would silently vanish in those buffers.

Servers are installed by mason via `ensure_installed` in
`lua/plugins/lsp.lua` (lspconfig names, not mason package names).

Inspect state with `:LspActiveClients`, `:LspInstalledClients`,
`:LspActiveConfig <name>`, and `:LspClearLog`.

## Formatting

`<leader>d` runs a per-filetype *chain* of tools in order, so a later tool wins
where two disagree. Formatting on save is off by default for every tool.

- `:FormatInfo` — what would run in this buffer, and why
- `:FormatOnSave [tool] [on|off|toggle|buffer|default|status]`
- `:FormatDebug` — per-step logging

Everything intended to be tweaked lives in the CONFIGURATION block at the top
of `lua/formatting.lua`.

## Keymaps

Leader is `\` (`` ` `` on macOS). `:K` or `<leader>m` lists everything.

| Keys | Does |
| --- | --- |
| `<leader>d` | Format buffer (see above) |
| `<leader>a` / `<leader>rn` | Code action / rename |
| `gd` / `gD` / `gi` / `<leader>rf` | Definition / declaration / implementation / references |
| `]d` / `[d` | Next / previous diagnostic |
| `]c` / `[c` | Next / previous git hunk |
| `]t` / `[t` | Next / previous test |
| `tn` / `tf` / `ts` | Run nearest test / file / suite |
| `<leader>t` / `<leader>f` / `<leader>b` | Find files / grep / buffers |
| `<leader>'` / `<leader>F` | Toggle file tree / reveal current file |
| `<leader>gg` / `<leader>gb` | Fugitive status / GBrowse |

## Plugins

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim); versions are
pinned in `lazy-lock.json`.

Notable: [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) (file tree),
[telescope](https://github.com/nvim-telescope/telescope.nvim) (pickers),
[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (completion),
[none-ls](https://github.com/nvimtools/none-ls.nvim) (non-LSP formatters),
[neotest](https://github.com/nvim-neotest/neotest) (rspec + minitest),
[gitsigns](https://github.com/lewis6991/gitsigns.nvim) and
[fugitive](https://github.com/tpope/vim-fugitive),
[onedark](https://github.com/navarasu/onedark.nvim).

nvim-treesitter is deliberately pinned to the frozen `master` line. The `main`
branch is a rewrite with a different API — see the comment in
`lua/plugins/treesitter.lua` before bumping it.

## Updating

```
:Lazy check          # what's behind
:Lazy update         # apply; rewrites lazy-lock.json
:checkhealth         # after any update
```

Commit `lazy-lock.json` on its own straight after updating — that gives you
`:Lazy restore` and a bisect target when something breaks later. Updating a
few plugins at a time (`:Lazy update telescope.nvim`) makes that bisect cheap.

Run `:checkhealth vim.deprecated` before bumping `nvim_version` in
`../setup.sh`; it lists API removals with the version they land in.
