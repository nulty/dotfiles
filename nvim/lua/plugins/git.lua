return {
  -- https://github.com/tpope/vim-fugitive
  {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
      vim.keymap.set('n', '<leader>gg', ":G<CR>")
      vim.keymap.set('n', '<leader>gb', ":.GBrowse<CR>")
      vim.keymap.set('x', '<leader>gb', ":GBrowse<CR>")
    end
  },
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        vim.keymap.set('n', ']c', function() gitsigns.nav_hunk('next') end, { buffer = bufnr, noremap = true })
        vim.keymap.set('n', '[c', function() gitsigns.nav_hunk('prev') end, { buffer = bufnr, noremap = true })
      end
    },
  },
}
