local function load_server_config(server_name)
  local path = "lsp_settings." .. server_name
  if pcall(require, path) then
    return require(path)
  end
end


return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { 'j-hui/fidget.nvim', opts = {} },
    },
    event = "BufEnter",
    config = function(plugin, _opts)
      local base_config = require('lsp_config')
      require 'mason'.setup()

      local enabled_servers = {
        -- bashls,
        -- black,
        -- crystalline,
        -- cssls,
        -- emmet_ls,
        -- eslint-ls,
        -- erb_lint,
        -- html,
        -- htmlhint,
        -- jsonlint,
        -- jsonls,
        'lua_ls',
        -- prettierd,
        -- pyright,
        -- rubocop,
        -- ruby_ls,
        -- rubyfmt,
        'solargraph',
        'stylelint_lsp',
        'tailwindcss',
        'tsserver',
        -- yamlls,
      }

      require 'mason-lspconfig'.setup(
        {
          handlers = {
            function(server_name)
              local server_config = load_server_config(server_name) or {}
              local config = vim.tbl_deep_extend("force", base_config, server_config)

              if vim.tbl_contains(enabled_servers, server_name) then
                require "lspconfig"[server_name].setup(config)
              end
            end
          }
        }
      )
    end
  },
  {
    -- https://github.com/nvimtools/none-ls.nvim
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    event = "VeryLazy",
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        debug = true,
        sources = {
          null_ls.builtins.formatting.erb_lint,
          null_ls.builtins.formatting.prettier.with {
            -- extra_args = { "--html-whitespace-sensitivity", "ignore" },
            extra_filetypes = { "astro" },
            disabled_filetypes = { 'eruby' }
          },
          null_ls.builtins.diagnostics.erb_lint,
          null_ls.builtins.formatting.stylelint,
          -- null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.black,
        }
      }
    end
  },
  -- {
  --   -- https://github.com/github/copilot.vim
  --   "github/copilot.vim",
  --   event = "VeryLazy",
  --   config = function()
  --     vim.cmd [[imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")]]
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_enabled = false
  --   end
  -- },
  { "folke/neodev.nvim", opts = {} },
}
