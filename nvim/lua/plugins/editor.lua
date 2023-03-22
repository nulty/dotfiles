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
}
