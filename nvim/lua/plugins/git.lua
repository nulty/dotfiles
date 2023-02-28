return {
  -- https://github.com/tpope/vim-fugitive
	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			-- {
			-- 	"<leader>gg",
			-- 	vim.api.nvim_command(":G"),
			-- 	desc = "Open Fugitive"
			-- }
		},
    config = function ()
      vim.keymap.set('n', '<leader>gg', ":G<CR>")
    end
	},
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    event = "BufEnter",
    config = true
  },
}
