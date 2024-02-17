local function lsp_package_names(packages)
  return vim.tbl_map(function(package)
    local res
    if vim.tbl_contains(package.spec.categories, "LSP") then
      res = package.name
    end
    return res
  end, packages)
end

local function load_server_config(server_name)
  local path = "lsp_settings." .. server_name
  if pcall(require, path) then
    return require(path)
  end
end
require('vim.lsp.log').set_format_func(vim.inspect)
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    event = "BufEnter",
    config = function(plugin, _opts)
      local names = lsp_package_names(require 'mason-registry'.get_installed_packages())

      -- lspconfig and mason use different names for some of the language servers
      -- So we need to map them here
      -- ["mason"] = "lspconfig",
      local server_mapping = {
        ["html-lsp"] = "html",
        ["json-lsp"] = "jsonls",
        ["bash-language-server"] = "bashls",
        ["tailwindcss-language-server"] = "tailwindcss",
        ["typescript-language-server"] = "tsserver",
        ["lua-language-server"] = "lua_ls",
        ["stylelint-lsp"] = "stylelint_lsp",
        ["emmet-ls"] = "emmet_ls",
        ["css-lsp"] = "cssls",
        ["yamllint"] = "yamlls",
        ["yaml-language-server"] = "yamlls",
      }

      for _, server in pairs(names) do
        local config
        local base_config = require('lsp_config')
        local server_name = server_mapping[server] or server
        local server_config = load_server_config(server_name)
        if server_config then
          config = vim.tbl_deep_extend("force", base_config, server_config)
        else
          config = base_config
        end

        if server_name == "cssls" then
        elseif server_name == "yamlls" then
          config = vim.tbl_deep_extend("force", base_config, {
            settings = {
              yaml = {
                schemaStore = {
                  enable = false,
                  url = "",
                },
                schemas = require('schemastore').yaml.schemas(),
              },
            },
          })

          require 'lspconfig'.yamlls.setup(config)
        elseif server_name == "jsonls" then
          config = vim.tbl_deep_extend("force", base_config, {
            capabilities = base_config.capabilities,
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
            -- The rest of your jslonls settings
          })

          require 'lspconfig'.jsonls.setup(config)
        else
          require "lspconfig"[server_name].setup(config)
        end
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
        debug = true,
        sources = {
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.erb_lint,
          null_ls.builtins.formatting.prettier.with {
            filetypes = {
              "htmldjango",
              "javascript",
              "eruby",
              "scss",
              "css"
            }
          },
          null_ls.builtins.diagnostics.erb_lint,
          null_ls.builtins.formatting.stylelint,
          -- null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.black,
        }
      }
    end
  },
  {
    -- https://github.com/github/copilot.vim
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      vim.cmd[[imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")]]
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_enabled = true
    end
  }
}
