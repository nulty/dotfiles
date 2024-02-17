return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    version = false,
    event = "BufEnter",
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
        "help",
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
        "yaml",
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/playground",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
  }
}
