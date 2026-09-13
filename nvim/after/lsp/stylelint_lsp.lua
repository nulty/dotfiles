-- filetypes decides where the server attaches; settings.stylelint.validate
-- decides what it will actually lint, and settings.stylelint.snippet where it
-- offers completions. lspconfig ships validate/snippet = { css, postcss } only,
-- so widening filetypes alone left the server attached to scss/sass/less and
-- silently doing nothing. Keep all three lists in step.
--
-- If a project reports `CssSyntaxError: Unknown word //` on every .scss file,
-- that is stylelint, not this config. stylelint never infers SCSS from the file
-- extension -- with no customSyntax set it parses .scss with the plain CSS
-- parser (see its lib/getPostcssResult.mjs), and `//` is not CSS. postcss-scss
-- is only a devDependency *of stylelint*, so it is not installed for you. Fix
-- the project:
--
--   yarn add --dev postcss-scss     (or npm i -D postcss-scss)
--
--   "overrides": [
--     { "files": ["**/*.scss"], "customSyntax": "postcss-scss" }
--   ]
--
-- The template in ../../.stylelintrc.json already carries that override.
---@type vim.lsp.Config
return {
  filetypes = { "css", "less", "sass", "scss" },
  settings = {
    stylelint = {
      validate = { "css", "less", "postcss", "sass", "scss" },
      snippet = { "css", "less", "postcss", "sass", "scss" },
    },
  },
}
