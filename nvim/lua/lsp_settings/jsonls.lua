-- Chrome Extension has index 166
-- It has no fileMatch for somereason
-- WebExtensions is the older version
-- Ignore WebExtensions and add fileMatch for "Chrome Extension"
local schemas = require('schemastore').json.schemas(
  {
    ignore = { "WebExtensions" }
  }
)
schemas[166].fileMatch = { "**/manifest.json" }

return {
  config = {
    settings = {
      json = {
        schemas = schemas,
        validate = { enable = true },
      },
    },
  }
}
