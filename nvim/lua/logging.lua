-- vim lsp
require('vim.lsp.log').set_format_func(vim.inspect)
-- vim.lsp.set_log_level was deprecated in 0.12 in favour of vim.lsp.log.set_level.
require('vim.lsp.log').set_level 'error'
