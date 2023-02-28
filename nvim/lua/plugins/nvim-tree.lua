return {
	"nvim-tree/nvim-tree.lua",
	dependencies =  {"nvim-tree/nvim-web-devicons"},
	init = function()
		-- nvim-tree suggests using a custom function to handle open on startup
		-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
		local open_nvim_tree = function(data)
			-- buffer is a directory
			local directory = vim.fn.isdirectory(data.file) == 1

			if not directory then
				return
			end

			-- change to the directory
			vim.cmd.cd(data.file)
			-- open the tree
			require("nvim-tree.api").tree.open()
		end
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
	end,
	opts = {
		view = {
			width = 40,
			mappings = {
				list = {
					{ key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
					{ key = "l", action = "edit" },
					{ key = { "<2-RightMouse>", "<C-]>", "+" }, action = "cd" },
					{ key = "s", action = "vsplit" },
					{ key = "<C-x>", action = "split" },
					{ key = "<C-t>", action = "tabnew" },
					{ key = "<", action = "prev_sibling" },
					{ key = ">", action = "next_sibling" },
					{ key = "P", action = "parent_node" },
					{ key = "<BS>", action = "close_node" },
					{ key = "<S-CR>", action = "close_node" },
					{ key = "<Tab>", action = "preview" },
					{ key = "K", action = "first_sibling" },
					{ key = "J", action = "last_sibling" },
					{ key = "I", action = "toggle_git_ignored" },
					{ key = "H", action = "toggle_dotfiles" },
					{ key = "R", action = "refresh" },
					{ key = "a", action = "create" },
					{ key = "d", action = "remove" },
					{ key = "r", action = "rename" },
					{ key = "<C-r>", action = "full_rename" },
					{ key = "x", action = "cut" },
					{ key = "c", action = "copy" },
					{ key = "p", action = "paste" },
					{ key = "y", action = "copy_name" },
					{ key = "Y", action = "copy_path" },
					{ key = "gy", action = "copy_absolute_path" },
					{ key = "[c", action = "prev_git_item" },
					{ key = "]c", action = "next_git_item" },
					{ key = "-", action = "dir_up" },
					{ key = "q", action = "close" },
					{ key = "g?", action = "toggle_help" },
					{ key = "o", action = "system_open" },
				}
			}

		},
		renderer = {
			group_empty = true,
			highlight_opened_files = "all",
		},
		filters = {
			dotfiles = true,
		},
	},
	keys = {
		{
			"<leader>'",
			function()
				require("nvim-tree").toggle()
			end,
			desc = "Toggle open/close nvim-tree"
		},
		{
			"<leader>F",
			function()
				require("nvim-tree").open({find_file=true})
			end,
			desc = "Find the current file in nvim-tree"
		}


	},
	config = true,
}
