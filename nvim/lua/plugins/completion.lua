return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and not luasnip.expand_or_locally_jumpable() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
              luasnip.jump( -1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs( -4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        sorting = {
          -- Table with a list of functions by which the competion
          -- results are sorting in the suggestions.
          -- kind puts the test ones towards the bottomg, at least
          -- https://github.com/hrsh7th/nvim-cmp/issues/381
          comparators = {
            cmp.config.compare.kind,
          }
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = string.format('%s', vim_item.kind)

            vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[LaTeX]",
                })[entry.source.name]

            return vim_item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    init = function()
      require("cmp_nvim_lsp").setup()
    end
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      -- https://github.com/rafamadriz/friendly-snippets
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }
}
