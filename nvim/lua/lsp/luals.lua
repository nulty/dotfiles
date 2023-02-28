local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = 'LuaJIT',
            path = {
                -- '?.lua',
                -- '?/init.lua',
                -- vim.fn.expand '~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?.lua',
                -- vim.fn.expand '~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?/init.lua',
                -- vim.split(package.path, ';'),
            },
            -- ***Formatting is controlled by .editorconfig***
            format = {
                -- enable = true,
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
            globals = { 'vim', 'nvim_lsp' },
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
