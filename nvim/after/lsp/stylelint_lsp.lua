-- filetypes decides where the server attaches; settings.stylelint.validate
-- decides what it will actually lint. lspconfig ships validate = { css,
-- postcss } only, so widening filetypes alone left the server attached to
-- scss/sass/less and silently doing nothing. Keep the two lists in step.
--
-- A project whose stylelint config lacks a scss-capable customSyntax (e.g.
-- postcss-scss) will now report CssSyntaxError on .scss files. That is the
-- project's config to fix, not this one's.
---@type vim.lsp.Config
return {
  filetypes = { "css", "less", "sass", "scss" },
  settings = {
    stylelint = {
      validate = { "css", "less", "postcss", "sass", "scss" },
    },
  },
}
