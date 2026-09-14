-- vim lsp
-- Don't set_format_func: it replaces the whole formatter, which in current
-- Nvim is `(level, ...)` -> string and is also what applies set_level. Passing
-- vim.inspect (the pre-0.10 per-argument signature) logs the bare level name,
-- drops the message, and defeats the level filter.
require('vim.lsp.log').set_level 'error'
