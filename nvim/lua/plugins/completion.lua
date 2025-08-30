return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local icons = require "icons"

      return {
        completion = {
          border = "rounded",
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
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
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "nvim_lua", priority = 700 },
          { name = "path", priority = 500 },
          { name = "buffer", priority = 250, keyword_length = 3 },
          { name = "emoji", priority = 100 },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,       -- Match position in word
            cmp.config.compare.exact,        -- Exact matches first
            cmp.config.compare.score,        -- LSP relevance
            cmp.config.compare.recently_used, -- Recently used
            cmp.config.compare.locality,     -- Nearby definitions
            cmp.config.compare.kind,         -- Group by type
            cmp.config.compare.sort_text,    -- Server suggestions
            cmp.config.compare.length,       -- Shorter names first
            cmp.config.compare.order,        -- Source order fallback
          }
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
            col_offset = -3,
            side_padding = 1,
            scrollbar = false,
            scrolloff = 8,
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- vim_item.kind = string.format('%s', vim_item.kind)
            vim_item.kind = icons.kind[vim_item.kind]

            vim_item.menu = ({
                  buffer = "[Buf]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[Snip]",
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
      -- require'luasnip'.log.set_loglevel("debug")
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end
  }
}
