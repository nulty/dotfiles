-- installation directory: /usr/local/.local/data/nvim/site/parser (shared via devs)
-- jsonc has no parser of its own on `main`; the json parser covers it.
local parsers = {
  "bash",
  "css",
  "scss",
  "diff",
  "dockerfile",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "http",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "regex",
  "ruby",
  "rust",
  "sql",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- The `main` branch is a rewrite of the old `master` line: it only installs
    -- parsers and queries, and features are switched on through Neovim itself.
    -- Needs tree-sitter-cli (from mise, not npm) and does not support lazy-loading.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local shared_data = require("shared_data")
      local install_dir = shared_data.dir .. "/site"
      require("nvim-treesitter").setup({ install_dir = install_dir })

      -- The installer creates directories as 0755 and builds parsers elsewhere
      -- before moving them in, so hand each install back to the devs group.
      local function share_with_devs()
        shared_data.share_with_devs(install_dir)
      end

      -- nvim-treesitter has no post-install event, so this wraps internals that
      -- :TSInstall/:TSUpdate look up at call time. If upstream changes their
      -- shape, skip the fixup rather than break installs.
      local install = require("nvim-treesitter.install")
      for _, name in ipairs({ "install", "update" }) do
        local original = install[name]
        if vim.is_callable(original) then
          install[name] = function(...)
            local task = original(...)
            if type(task) == "table" and vim.is_callable(task.await) then
              pcall(task.await, task, share_with_devs)
            end
            return task
          end
        end
      end

      -- No-op for parsers that are already installed
      require("nvim-treesitter").install(parsers)

      -- Highlight every filetype that has a parser, like `highlight.enable` did
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
