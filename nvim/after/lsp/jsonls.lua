-- Chrome Extension has index 166. It has no fileMatch for some reason.
-- WebExtensions is the older version, so ignore it and add the fileMatch.
local schemas = require('schemastore').json.schemas({
  ignore = { "WebExtensions" },
})
schemas[166].fileMatch = { "**/manifest.json" }

---@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = schemas,
      validate = { enable = true },
    },
  },
}
