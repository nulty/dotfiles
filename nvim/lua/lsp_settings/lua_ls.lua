local conf =  {
	Lua = {
		runtime = {
			-- LuaJIT in the case of Neovim
			version = 'LuaJIT',
			path = {
				-- '/usr/local/share/nvim/runtime/?/?.lua',
				-- All lua files in the current directory
				'?.lua',
				'?/init.lua',
				-- All lua files from the Lua install on the system
				vim.fn.expand '~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?.lua',
				vim.fn.expand '~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?/init.lua',

				-- All lua files in core neovim
				vim.split(package.path, ';', { trimempty = true }),
				--vim.split(package.cpath, ';', { trimempty = true }),
				-- All lua files in installed packages
				vim.fn.expand '~/.local/share/nvim/lazy/?/?.lua',
			},
			-- ***Formatting is controlled by .editorconfig***
			format = {
				enable = true,
				-- Put format options here
				-- NOTE: the value should be STRING!!
				defaultConfig = {
					indent_style = "space",
					indent_size = "4",
				}
			},
		},

		diagnostics = {
			-- Get the language server to recognize the `vim` global
			enable = true,
			globals = { 'vim' },
			-- neededFileStatus = {
			--   ["codestyle-check"] = "Any",
			-- },
		},
		workspace = {
			-- Make the server aware of Neovim runtime files
			-- library = vim.api.nvim_get_runtime_file("", true),
			library = {
				vim.api.nvim_get_runtime_file("", true),
				[vim.fn.expand('$VIMRUNTIME/**/*.lua')] = true,
				-- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp/*')] = true,
			},
		},
	}
}
return conf
