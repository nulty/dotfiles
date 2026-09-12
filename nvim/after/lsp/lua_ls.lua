---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      runtime = {
        -- LuaJIT in the case of Neovim
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        enable = true,
        globals = { 'vim' },
      },
      -- No workspace.library here on purpose: lazydev.nvim adds the libraries
      -- for the modules a file actually requires. Setting it statically would
      -- load everything up front, which is what lazydev exists to avoid.
      workspace = {
        checkThirdParty = true,
      },
    },
  },
}
