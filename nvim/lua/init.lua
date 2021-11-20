-- require('generate_keymaps')
-- local nvim_status = require"lsp-status"
-- 1. get the default config from nvim-lspconfig
-- local config = require"lspinstall/util".extract_config("stylelint_lsp")
-- 2. update the cmd. relative paths are allowed, lspinstall automatically adjusts the cmd and cmd_cwd for us!
-- config.default_config.cmd[1] = "./node_modules/.bin/stylelint-lsp"

-- 3. extend the config with an install_script and (optionally) uninstall_script
-- require'lspinstall/servers'.stylelint_lsp = vim.tbl_extend('error', config, {
--   -- lspinstall will automatically create/delete the install directory for every server
--   install_script = [[
--   ! test -f package.json && npm init -y --scope=lspinstall || true
--   npm install stylelint-lsp@latest
--   ]],
--   uninstall_script = [[npm uninstall stylelint-lsp@latest]]
-- })


-- LSP and LSPCONFIG
--
-- local filetypes = {
--   typescript = {'stylelint'},
--   typescriptreact = {'stylelint'},
--   css = {'stylelint'}
-- }
-- local linters = {
--   stylelint = {
--     sourceName = 'stylelint',
--     command = 'stylelint',
--     args = {'--formatter', 'compact', '%filepath'},
--     rootPatterns = {'.stylelintrc'},
--     debounce = 100,
--     formatPattern = {
--       [[: line (\d+), col (\d+), (warning|error) - (.+?) \((.+)\)]],
--       {
--         line = 1,
--         column = 2,
--         security = 3,
--         message = {4, ' [', 5, ']'},
--       },
--     },
--     securities = {
--       warning = 'warning',
--       error = 'error',
--     },
--   },
-- }
--
-- local formatters = {
--   stylelint = {
--     command = 'stylelint',
--     args = {'--fix', '--stdin', '--stdin-filename', '%filepath'},
--   }
-- }
-- local formatFiletypes = {
--   typescript = {'stylelint'},
--   typescriptreact = {'stylelint'},
-- }
--
-- nvim_lsp.diagnosticls.setup {
--   filetypes = vim.tbl_keys(filetypes),
--   init_options = {
--     filetypes = filetypes,
--     linters = linters,
--     formatters = formatters,
--     formatFiletypes = formatFiletypes,
--   }
-- }

-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.rust_analyzer.setup{}
--

-- require'lspconfig'.stylelint_lsp.setup{
--   settings = {
--     stylelintplus = {
--       autoFixOnFormat = true,
--       autoFixOnSave = true,
--       configFile = ".stylelintrc.json"
--     }
--   }
-- }
-- vim.lsp.set_log_level("debug")
require('vim.lsp.log').set_level("trace")

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

-- TODO: Consider using this. I do kind of like it :)
-- local nnoremap = vim.keymap.nnoremap

-- config that activates keymaps and enables snippet support
local function make_config()
  -- keymaps
  local custom_attach = function(client, bufnr)

    -- print("LSP name:" .. vim.inspect(client.name))
    -- print("Printing the client info:" .. vim.inspect(client))

    -- require('completion').on_attach()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Mappings.
    local opts = { noremap=true, silent=false }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-/>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], false)
    end
  end

  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  updated_capabilities.textDocument.codeLens = {
    dynamicRegistration = false,
  }
  -- updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
  updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
  updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = updated_capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = custom_attach,
  }
end

require('lspconfig').solargraph.setup(make_config())
require('lspconfig').vimls.setup(make_config())
-- lsp-install
local function setup_servers()
  require'lspinstall'.setup()

  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()
  -- ... and add manually installed servers
  table.insert(servers, "typescript")

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua" then
      config.settings = lua_settings
    end

    require'lspconfig'[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
require'completion'
require'nvim_tree'
