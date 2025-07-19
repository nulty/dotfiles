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
        'cssls',
        'emmet_language_server',
        'eslint-lsp',
        'erb-lint',
        'html',
        -- htmlhint,
        -- jsonlint,
        -- jsonls,
        'lua_ls',
        -- 'prettier',
        -- pyright,
        'rubocop',
        'ruby_lsp',
        -- 'htmlbeautifier',
        -- rubyfmt,
        -- 'solargraph',
        'stylelint_lsp',
        -- 'tailwindcss',
        'tsserver',
        'yamlls'
      }

      require 'mason-lspconfig'.setup(
        {
          automatic_installation = {},
          ensure_installed = { 'rubocop' },
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
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim"
    },
    event = "VeryLazy",
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        debug = true,
        sources = {
          require("none-ls.formatting.jq"),
          -------------------
          -- RUN PRETTIER BEFORE ESLINT
          -- -----------------
          null_ls.builtins.formatting.prettier.with {
            extra_args = {
              "--html-whitespace-sensitivity",
              "ignore",
              "--prose-wrap",
              "always"
            },
            -- extra_filetypes = { "astro", "tsx" },
            -- extra_filetypes = { "astro", "tsx", "eruby" },
            disabled_filetypes = { 'eruby' }
          },
          require("none-ls.diagnostics.eslint"),
          require("none-ls.formatting.eslint").with({
            --extra_args = { "--fix" },
            extra_args = { "-c", "eslint.config.js" },
          }),

          -------------------
          -- RUN HTMLBEAUTIFIER BEFORE ERBLINT
          -- -----------------
          null_ls.builtins.formatting.htmlbeautifier.with({
            extra_args = {
              "--keep-blank-lines",
              "1"
            }
          }),
          null_ls.builtins.formatting.erb_lint,
          null_ls.builtins.diagnostics.erb_lint,
          -- null_ls.builtins.formatting.rubyfmt,
          null_ls.builtins.formatting.rubocop.with {
            args = { "-c", "./.rubocop.yml", "-A", "--server", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
          },
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
