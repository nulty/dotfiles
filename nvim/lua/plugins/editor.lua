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
    "iamcco/markdown-preview.nvim",
    build = 'cd app && yarn install',
    ft = { "markdown" },
  },
  {
    "vim-crystal/vim-crystal",
    event = "BufEnter"
  },
  {
    "tpope/vim-rhubarb",
    event = "BufEnter"
  },
  {
    "tpope/vim-unimpaired",
    event = "BufEnter"
  },
  {
    "tpope/vim-rails",
    event = "BufEnter",
    cond = function()
      return vim.fn.filereadable("Gemfile") == 1
    end
  },
  {
    -- https://github.com/junegunn/vim-easy-align
    "junegunn/vim-easy-align",
    event = "BufEnter",
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = { 'o', 'x', 'v', 's', 'l' } }
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
    event = "BufEnter",
    ft = { "markdown", "text", "gitcommit" },
  },
  {
    -- https://github.com/b0o/SchemaStore.nvim
    "b0o/SchemaStore.nvim",
    event = "BufEnter"
  },
}
