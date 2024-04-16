local active_lsps = function()
  return vim.tbl_map(function(e) return e.name end, vim.lsp.get_active_clients())
end

-- :K to start Telescope with current keymaps
vim.api.nvim_create_user_command('K', function() vim.cmd [[:Telescope keymaps]] end, {})

vim.api.nvim_create_user_command('LspActiveClients', function()
  P(active_lsps())
end, { desc = "Print the active LSP clients" })

vim.api.nvim_create_user_command('LspInstalledClients', function()
  P(require'mason-lspconfig'.get_installed_servers())
end, { desc = "Print the installed LSP clients" })

vim.api.nvim_create_user_command('LspActiveConfig', function(arg)
  P(vim.lsp.get_active_clients({ name = arg.args }))
end, { nargs = 1, desc = "Print the active configuration for the LSP", complete = active_lsps })
