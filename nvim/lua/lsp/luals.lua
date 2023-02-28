local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = 'LuaJIT',
            path = {
                '?.lua',
                '?/init.lua',
                vim.fn.expand'~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?.lua',
                vim.fn.expand'~/.asdf/installs/lua/5.1.5/luarocks/share/lua/5.1/luarocks/?/init.lua',
                vim.split(package.path, ';'),
            },
            -- ***Formatting is controlled by .editorconfig***
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
            library = {
                vim.api.nvim_get_runtime_file("", true),
                [vim.fn.expand('$VIMRUNTIME/lua/?/?.lua')] = true
            },
        },
    }
}

return lua_settings
