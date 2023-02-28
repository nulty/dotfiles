return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    event = "BufEnter",
    config = function(plugin, _opts)
      local config = require('lsp_setup').setup_event()
      local servers = require 'mason-registry'.get_installed_package_names()

      -- lspconfig and mason use different names for some of the language servers
      -- So we need to map them here
      -- ["mason"] = "lspconfig",
      local server_mapping = {
        ["tailwindcss-language-server"] = "tailwindcss",
        ["typescript-language-server"] = "tsserver",
        ["lua-language-server"] = "lua_ls",
        ["stylelint-lsp"] = "stylelint_lsp",
        ["yamllint"] = "yamlls",
      }
      --local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, server in pairs(servers) do
        local server_name = server_mapping[server] or server
        local path = "lsp_settings." .. server_name
        if pcall(require, path) then
          local settings = require(path)
          if settings then
            config.settings = settings
          end
        end
        --config.capabilities = capabilities
        require "lspconfig"[server_name].setup(config)
      end
    end
  },
  {
    "williamboman/mason.nvim",
    init = function()
      require 'mason'.setup()
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    event = "VeryLazy",
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        source = {
          null_ls.builtins.formatting.prettierd
        }
      }
    end
  }
}
