return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    event = "BufEnter",
    build = ":TSUpdate",
    opts = {
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
        "help",
        "html",
        "http",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "ruby",
        "rust",
        "sql",
        "typescript",
        "vim",
        "yaml",
      },
    },
  }
}
