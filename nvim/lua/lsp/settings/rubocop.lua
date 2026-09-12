-- https://github.com/rubocop/rubocop
---@type vim.lsp.Config
return {
  -- cmd = { 'bundle', 'exec', 'rubocop', '--server', '-S', '-c', '.rubocop.yml' },
  cmd = { 'rubocop', '--server', '-S', '-c', '.rubocop.yml' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.rubocop.yml', '.git' },
}
