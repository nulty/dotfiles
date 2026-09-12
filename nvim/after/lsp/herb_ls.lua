-- herb_ls defaults formatter.enabled = false unless the project has a
-- .herb.yml (see @herb-tools/language-server settings.js). Enable it via the
-- client settings so <leader>d works without needing a config file.
--
-- fixOnSave stays off: it is a linter autofix applied by the server outside
-- the format path, so it fought <leader>d over void elements. Formatting on
-- save now goes through format_buffer() in lua/lsp_config.lua instead.
---@type vim.lsp.Config
return {
  settings = {
    languageServerHerb = {
      formatter = { enabled = true },
      linter = { enabled = true, fixOnSave = false },
    },
  },
}
