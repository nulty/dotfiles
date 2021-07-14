-- 1. get the default config from nvim-lspconfig
local config = require"lspinstall/util".extract_config("stylelint_lsp")
-- 2. update the cmd. relative paths are allowed, lspinstall automatically adjusts the cmd and cmd_cwd for us!
config.default_config.cmd[1] = "node ./node_modules/stylelint-lsp/dist/index.js --stdio"

-- 3. extend the config with an install_script and (optionally) uninstall_script
require'lspinstall/servers'.stylelint = vim.tbl_extend('error', config, {
  -- lspinstall will automatically create/delete the install directory for every server
  install_script = [[
  ! test -f package.json && npm init -y --scope=lspinstall || true
  npm install stylelint-lsp@latest
  ]],
  uninstall_script = [[npm uninstall stylelint-lsp@latest]]
})

