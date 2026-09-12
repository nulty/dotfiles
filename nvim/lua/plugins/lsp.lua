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
      require 'mason'.setup()

      require 'mason-lspconfig'.setup({
        automatic_installation = {},
        -- lspconfig names, not Mason package names (mason-lspconfig v2).
        ensure_installed = {
          'rubocop',
          'lua_ls',
          'ruby_lsp',
          'stylelint_lsp',
          'herb_ls',
          'eslint',
        },
      })

      -- Shared defaults applied to every server mason-lspconfig auto-enables.
      vim.lsp.config('*', require('lsp_config'))

      -- eslint's LSP client can format on save; it is gated by the shared
      -- registry in lua/formatting.lua, so :FormatOnSave eslint on|off
      -- governs it like every other tool. Off by default.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= 'eslint' then return end
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              if not require('formatting').on_save_enabled(args.buf, 'eslint') then return end
              vim.lsp.buf.format({
                bufnr = args.buf,
                async = false,
                filter = function(c) return c.name == 'eslint' end,
              })
            end,
          })
        end,
      })

      -- :HerbInit drops the preferred .herb.yml template into the nearest
      -- Gemfile/.git root so per-project rule tuning picks up immediately.
      vim.api.nvim_create_user_command('HerbInit', function()
        local template = vim.fn.stdpath('config') .. '/templates/herb.yml'
        local root = vim.fs.root(0, { 'Gemfile', '.git' }) or vim.fn.getcwd()
        local target = root .. '/.herb.yml'
        if vim.uv.fs_stat(target) then
          vim.notify('.herb.yml already exists at ' .. target, vim.log.levels.WARN)
          return
        end
        local ok, err = vim.uv.fs_copyfile(template, target)
        if not ok then
          vim.notify('Failed to copy herb template: ' .. tostring(err), vim.log.levels.ERROR)
          return
        end
        vim.notify('Wrote ' .. target)
      end, { desc = 'Copy default .herb.yml template into project root' })
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

          -- herb_ls owns HTML+ERB layout; erb_lint is additive for the Ruby
          -- inside ERB tags (autofix + diagnostics). Both are gated on a
          -- project opting in via .erb-lint.yml. On <leader>d both run —
          -- erb_lint rewrites Ruby, herb normalises surrounding layout.
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
  {
    -- Replaces neodev.nvim (EOL). Lazily feeds LuaLS the workspace libraries
    -- for whatever modules the open file actually requires.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types only when `vim.uv` is mentioned
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
