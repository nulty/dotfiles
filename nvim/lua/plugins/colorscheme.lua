return {
	{
		'navarasu/onedark.nvim',
		lazy = false,
		priority = 1000,
		init = function()
			require("onedark").setup {
				style = "darker",
				code_style = {
					comments = 'italic'
				},
				--transparent = true,
			}
			require("onedark").load()
		end
	}
}
