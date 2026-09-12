-- Launch ruby-lsp through `mise x` with cwd=root_dir so it picks up the
-- project's Ruby (.mise.toml / .tool-versions / .ruby-version) instead of
-- mise's global Ruby. Preserves the built-in cmd_cwd behaviour from
-- nvim-lspconfig's lsp/ruby_lsp.lua so mise resolves from the project.
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { 'mise', 'x', '--', 'ruby-lsp' },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
}
