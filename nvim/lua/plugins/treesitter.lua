return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    -- Deliberately pinned to the frozen `master` line (v0.9.3-181-g4423f305).
    -- The `main` branch is a rewrite with a different API: no
    -- nvim-treesitter.configs, parsers via :TSInstall only, highlight enabled
    -- by autocmd. Migrating is a separate piece of work; don't bump blindly.
    branch = "master",
    commit = "4423f3053964461656c7432fd33f205ef88a6168",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    init = function()
      -- if os.execute("npm ls -g tree-sitter-cli") ~= 0 then
      --   os.execute("npm install -g tree-sitter-cli")
      -- end
    end,
    opts = {
      highlight = {
        enable = true
      },
      -- installation directory: ~/.local/share/nvim/lazy/nvim-treesitter/parser
      ensure_installed = {
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
        "jsonc",
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
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
