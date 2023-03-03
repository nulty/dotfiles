-- vim lsp
-- require('vim.lsp.log').set_level("debug")
vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
require('vim.lsp.log').set_format_func(vim.inspect)

vim.lsp.set_log_level 'trace'
-- print(vim.inspect(vim.lsp.log_levels))
