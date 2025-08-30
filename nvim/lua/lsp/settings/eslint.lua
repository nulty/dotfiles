return {
  on_attach = function(_client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(c)
            return c.name == "eslint"
          end,
          async = false,
        })
      end,
    })
  end,
  -- root_dir = function(path)
  -- vim.print(path)
  -- local eslint = vim.fs.find({ 'eslintrc.js', 'eslint.config.js' }, {
  --   upward = true,
  --   stop = vim.loop.os_homedir(),
  --   path = vim.fs.dirname(path),
  -- })
  --
  -- vim.print(vim.fs.dirname(eslint[1]))
  --
  -- return vim.fs.dirname(eslint[1])
  -- end,
  settings = {
    debug = true,
    useFlatConfig = true,
    -- runtime = "node",
  }
}
