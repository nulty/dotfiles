local lua_settings = {
  Lua = {
      runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = {
        '?.lua',
        '?/init.lua',
        vim.fn.expand'~/.luarocks/share/lua/5.3/?.lua',
        vim.fn.expand'~/.luarocks/share/lua/5.3/?/init.lua',
        '/usr/share/5.3/?.lua',
        '/usr/share/lua/5.3/?/init.lua',
        vim.split(package.path, ';'),
      }
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      enable = true,
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}
return lua_settings
