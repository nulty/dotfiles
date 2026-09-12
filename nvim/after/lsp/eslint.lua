---@type vim.lsp.Config
-- Format-on-save lives in an LspAttach autocmd in lua/plugins/lsp.lua, not in
-- an on_attach here: a server-level on_attach replaces the shared one set by
-- vim.lsp.config('*', ...), which would drop every LSP keymap in eslint buffers.
return {
  settings = {
    debug = true,
    useFlatConfig = true,
  },
}
