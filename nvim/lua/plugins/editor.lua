return {
  {
    -- https://github.com/akinsho/toggleterm.nvim
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<leader>T]]
    },
    config = true,
    event = "VeryLazy"
  },
  {
    -- build downloads a prebuilt binary rather than running `yarn install`
    -- in the plugin's own checkout: yarn rewrote app/yarn.lock and left an
    -- untracked app/package-lock.json, which blocked every later :Lazy update.
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
  },
  {
    "vim-crystal/vim-crystal",
    ft = "crystal"
  },
  {
    "tpope/vim-rhubarb",
    event = "VeryLazy"
  },
  {
    "tpope/vim-unimpaired",
    event = "VeryLazy"
  },
  {
    -- No cond: it was evaluated once at startup against the cwd, so opening
    -- nvim from a subdirectory of an app skipped the plugin entirely.
    -- vim-rails already no-ops outside a Rails project.
    "tpope/vim-rails",
    ft = { "ruby", "eruby" }
  },
  {
    -- https://github.com/junegunn/vim-easy-align
    "junegunn/vim-easy-align",
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } }
    }
  },
  {
    -- https://github.com/sindrets/winshift.nvim
    "sindrets/winshift.nvim",
    event = "VeryLazy",
  },
  {
    -- https://github.com/dkarter/bullets.vim
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
  },
  {
    -- https://github.com/b0o/SchemaStore.nvim
    -- No event: after/lsp/{jsonls,yamlls}.lua require() it, which is what
    -- triggers the load.
    "b0o/SchemaStore.nvim",
    lazy = true
  },
}
