return {
  {
    -- https://github.com/stevearc/conform.nvim
    --
    -- Runs the CLI formatters. What runs where is described in
    -- lua/formatting.lua, which also owns :FormatInfo/:FormatOnSave/:FormatDebug
    -- and hands conform its setup table.
    "stevearc/conform.nvim",
    -- BufWritePre so format-on-save works on the first write of a session;
    -- <leader>d loads it through require('conform') the rest of the time.
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return require('formatting').conform_opts()
    end,
  },
}
