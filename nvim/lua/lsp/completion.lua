local function can_execute(arg)
    return vim.fn[arg]() == 1
end

-- Setup nvim-cmp.
--
require("cmp_nvim_ultisnips").setup{
    filetype_source = "treesitter"
}

local cmp = require'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

function cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
    cmp_ultisnips_mappings.compose{ "expand", "jump_forwards", "select_next_item" } (fallback)
end

function cmp_ultisnips_mappings.jump_forwards(fallback)
    cmp_ultisnips_mappings.compose{ "expand", "jump_forwards", "select_next_item" } (fallback)
end

function cmp_ultisnips_mappings.jump_backwards(fallback)
    cmp_ultisnips_mappings.compose{ "jump_backwards", "select_prev_item" } (fallback)
end

cmp.setup({
    view = {
        entries = "custom" -- can be "custom", "wildmenu" or "native"
    },
    formatting = {
        format = function (entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s', vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  ultisnips = "[USnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[LaTeX]",
              })[entry.source.name]
            return vim_item
        end
    },
    snippet = {
        expand = function (args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(
        -- Tab will select the current option in the list or the first
        -- if the cursor is not in the list yet.
        -- Otherwise it will fallback to normal tab
            function (fallback)
                local entry = cmp.get_active_entry() or cmp.get_entries()[1]

                if entry == nil and not can_execute("UltiSnips#CanJumpForwards") then return fallback() end

                if entry and not can_execute("UltiSnips#CanJumpForwards") then
                    cmp.confirm({ select = true })
                else
                    cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                end
            end,
            { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
        ["<S-Tab>"] = cmp.mapping(
            function (fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end,
            { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    sorting = {
        comparators = {
            cmp.config.compare.kind
        }
    },
    experimental = {
        ghost_text = false,
        native_menu = false
    }
}
)
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
    })
})
