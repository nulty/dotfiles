-- Launch ruby-lsp through `mise x` with cwd=root_dir so it picks up the
-- project's Ruby (.mise.toml / .tool-versions / .ruby-version) instead of
-- mise's global Ruby. Preserves the built-in cmd_cwd behaviour from
-- nvim-lspconfig's lsp/ruby_lsp.lua so mise resolves from the project.
--
-- Naming `ruby` activates only that tool. A bare `mise x` activates every tool
-- in scope, including the ones from the shared /usr/local config that ruby-lsp
-- has no use for -- and any one of those failing to resolve takes `mise x` down
-- with it before ruby-lsp ever starts. No version here on purpose: mise still
-- resolves it from config, falling back to the global Ruby outside a project.
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { 'mise', 'x', 'ruby', '--', 'ruby-lsp' },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
}
