return {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  root_dir = function(path)
    local eslint = vim.fs.find({ 'eslintrc.js', 'eslint.config.js' }, {
      upward = true,
      stop = vim.loop.os_homedir(),
      path = vim.fs.dirname(path),
    })

    vim.print(vim.fs.dirname(eslint[1]))

    return vim.fs.dirname(eslint[1])
  end,
  settings = {
    debug = true,
    experimental = {
      useFlatConfig = true
    },
    workingDirectories = "/home/iain/Code/bdsally/wix-blocker"
    -- runtime = "node",
    -- lintTask = {
    --   options = "-c eslint.config.js"
    -- }
  }
}
