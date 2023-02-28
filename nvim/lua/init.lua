require('vim.lsp.log').set_level("debug")

require('mason').setup({})
-- config that activates keymaps and enables snippet support
local function make_config()
  -- keymaps
  local custom_attach = function (client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Mappings.
    local opts = { noremap = true, silent = false }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>A', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-/>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
    if client.name == "pyright" then
      buf_set_keymap('n', '<leader>d', '<cmd>:Black<CR>', opts)
      -- elseif client.name == "tailwindcss-language-server" then
      --     buf_set_keymap('n', '<leader>d', '<cmd>!prettier -w %<CR>', opts)
    else
      buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
      vim.api.nvim_exec([[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], false)
    end
  end


  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.codeLens = {
    dynamicRegistration = false,
  }

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return {
    capabilities = capabilities,
    on_attach = custom_attach,
  }
end

local server_mapping = {
  ["tailwindcss-language-server"] = "tailwindcss",
  ["typescript-language-server"] = "tsserver",
  ["lua-language-server"] = "lua_ls",
  ["stylelint-lsp"] = "stylelint_lsp",
  ["yamllint"] = "yamlls",
}

local function setup_servers()
  local servers = require'mason-registry'.get_installed_package_names()

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua-language-server" then
      config.settings = require('lsp.luals')
    end

    if server == "emmet_ls" then
      config.filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'eruby' }
    end

    if server == "rust" then
      config.setting = require('lsp.rust_analyzer')
    end

    -- if server ~= "tsserver" and server ~= "eslint" then
    local server_name = server_mapping[server] or server
    if server == "prettier" then
    else
      require'lspconfig'[server_name].setup(config)
    end
  end
end

setup_servers()

vim.cmd[[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
require'treesitter'
require('comment')
require'lsp/completion'
require'null_ls'
-- vim.lsp.set_log_level("debug")
