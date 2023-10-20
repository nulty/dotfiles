return {
  -- https://github.com/tpope/vim-fugitive
  {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
      vim.keymap.set('n', '<leader>gg', ":G<CR>")
    end
  },
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    event = "BufEnter",
    opts = {
      on_attach = function(bufnr)
        vim.keymap.set('n', ']c', '<CMD> lua require"gitsigns".next_hunk()<CR>', { buffer = bufnr, noremap = true })
        vim.keymap.set('n', '[c', '<CMD> lua require"gitsigns".prev_hunk()<CR>', { buffer = bufnr, noremap = true })
      end
    },
    config = function(config)
      local setup = {
        on_attach = config.opts.on_attach,
      }

      require('gitsigns').setup(setup)
    end
  },
}
