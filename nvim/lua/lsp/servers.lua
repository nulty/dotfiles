local M = {}

-- Helper function to load server-specific settings
local function load_settings(server_name)
  local ok, settings = pcall(require, 'lsp.settings.' .. server_name)
  if ok then
    return settings
  end
  return {}
end

-- Server configuration with enable/disable flags and settings
M.servers = {
  -- Web Development
  cssls = {
    enabled = true,
    settings = load_settings('css_ls')
  },
  html = {
    enabled = true
  },
  tsserver = {
    enabled = true
  },
  emmet_language_server = {
    enabled = true,
    settings = load_settings('emmet_ls')
  },
  
  -- Linting & Formatting
  ['eslint-lsp'] = {
    enabled = true,
    settings = load_settings('eslint')
  },
  stylelint_lsp = {
    enabled = true,
    settings = load_settings('stylelint_lsp')
  },
  
  -- Ruby
  ruby_lsp = {
    enabled = true
  },
  rubocop = {
    enabled = true,
    settings = load_settings('rubocop')
  },
  
  -- Lua
  lua_ls = {
    enabled = true,
    settings = load_settings('lua_ls')
  },
  
  -- YAML
  yamlls = {
    enabled = true,
    settings = load_settings('yamlls')
  },
  
  -- JSON
  jsonls = {
    enabled = false, -- Currently disabled in your config
    settings = load_settings('jsonls')
  },
  
  -- CSS Frameworks
  tailwindcss = {
    enabled = false, -- Currently disabled in your config
    settings = load_settings('tailwindcss')
  },
  
  -- Template Languages
  ['erb-lint'] = {
    enabled = true
  }
}

-- Get server configuration for mason-lspconfig
function M.get_server_config(server_name)
  local server_info = M.servers[server_name]
  if not server_info or not server_info.enabled then
    return nil
  end
  
  local base_config = require('lsp_config')
  return vim.tbl_deep_extend("force", base_config, server_info.settings or {})
end

-- Server categories for organization
M.categories = {
  web = { 'cssls', 'html', 'tsserver', 'emmet_language_server' },
  linting = { 'eslint-lsp', 'stylelint_lsp' },
  ruby = { 'ruby_lsp', 'rubocop', 'erb-lint' },
  lua = { 'lua_ls' },
  data = { 'yamlls', 'jsonls' },
  css_frameworks = { 'tailwindcss' }
}

return M