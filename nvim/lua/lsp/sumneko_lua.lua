local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = 'LuaJIT',
            path = {
                '?.lua',
                '?/init.lua',
                vim.fn.expand '~/.luarocks/share/lua/5.3/?.lua',
                vim.fn.expand '~/.luarocks/share/lua/5.3/?/init.lua',
                '/usr/share/5.3/?.lua',
                '/usr/share/lua/5.3/?/init.lua',
                vim.split(package.path, ';'),
            },
            -- format = {
            --   enable = true,
            --   -- Put format options here
            --   -- NOTE: the value should be STRING!!
            --   defaultConfig = {
            --     indent_style = "space",
            --     indent_size = "2",
            --   }
            -- },
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
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
        },
    }
}
return lua_settings
