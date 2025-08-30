local util = require 'lspconfig.util'

return {
  default_config = {
    -- cmd = { 'bundle', 'exec', 'rubocop', '--server', '-S', '-c', './rubocop.yml' },
    cmd = { 'rubocop', '--server', '-S', '-c', './rubocop.yml' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.rubocop.yml', '.git'),
  },
  docs = {
    description = [[
https://github.com/rubocop/rubocop
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
