
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
      local servers = require('lsp.servers')
      require 'mason'.setup()

      require 'mason-lspconfig'.setup({
        automatic_installation = {},
        ensure_installed = { 'rubocop' },
      })

      -- Shared defaults applied to every server mason-lspconfig auto-enables.
      vim.lsp.config('*', require('lsp_config'))

      -- Launch ruby-lsp through `mise x` with cwd=root_dir so it picks up
      -- the project's Ruby (.mise.toml / .tool-versions / .ruby-version)
      -- instead of mise's global Ruby. Preserves the built-in cmd_cwd behaviour
      -- from nvim-lspconfig's lsp/ruby_lsp.lua so mise resolves from the project.
      vim.lsp.config('ruby_lsp', {
        cmd = function(dispatchers, config)
          return vim.lsp.rpc.start(
            { 'mise', 'x', '--', 'ruby-lsp' },
            dispatchers,
            config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
          )
        end,
      })

      -- herb_ls defaults formatter.enabled = false unless the project has a
      -- .herb.yml (see @herb-tools/language-server settings.js). Enable it via
      -- the client settings so <leader>d works without needing a config file.
      vim.lsp.config('herb_ls', {
        settings = {
          languageServerHerb = {
            formatter = { enabled = true },
            linter = { enabled = true, fixOnSave = true },
          },
        },
      })
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
        on_attach = require('lsp_config').on_attach,
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

          -- ERB pipeline: when a project opts in via .erb-lint.yml, run
          -- htmlbeautifier (HTML layout) then erb_lint (ERB tags + diagnostics).
          -- Otherwise herb_ls handles ERB formatting + diagnostics on its own.
          null_ls.builtins.formatting.htmlbeautifier.with({
            extra_args = { "--keep-blank-lines", "1" },
            condition = function(utils)
              return utils.root_has_file({ ".erb-lint.yml", ".erb_lint.yml" })
            end,
          }),
          null_ls.builtins.formatting.erb_lint.with({
            condition = function(utils)
              return utils.root_has_file({ ".erb-lint.yml", ".erb_lint.yml" })
            end,
          }),
          null_ls.builtins.diagnostics.erb_lint.with({
            condition = function(utils)
              return utils.root_has_file({ ".erb-lint.yml", ".erb_lint.yml" })
            end,
          }),
          -- null_ls.builtins.formatting.rubyfmt,
          null_ls.builtins.formatting.rubocop,
          -- null_ls.builtins.formatting.rubocop.with {
          --   args = { "-c", "./.rubocop.yml", "-A", "--server", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
          -- },
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
