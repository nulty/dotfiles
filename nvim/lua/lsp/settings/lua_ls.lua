return {
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
        -- neededFileStatus = {
        --   ["codestyle-check"] = "Any",
        -- },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        -- library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = true,
        -- libarary = {
        --   unpack(vim.api.nvim_get_runtime_file('', true)),
        --   -- "${3rd}/luv/library",
        --   -- "${3rd}/busted/library",
        --   vim.env.VIMRUNTIME,
        -- },
        library = vim.api.nvim_get_runtime_file('', true),
      },
    }
  }
}
