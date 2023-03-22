return {
  -- https://github.com/numToStr/Comment.nvim
  {
    'numToStr/Comment.nvim',
    event = "BufEnter",
    config = true
  },

  {
    'AndrewRadev/splitjoin.vim',
    event = "VeryLazy",
    keys = {
      { "<leader>j", ":SplitjoinJoin<cr>" },
      { "<leader>l", ":SplitjoinSplit<cr>" },
    }
  },
  -- { 'AndrewRadev/tagalong.vim', event = "VeryLazy" },
  -- https://github.com/AndrewRadev/switch.vim
  { 'AndrewRadev/switch.vim', event = "VeryLazy" },
  -- https://github.com/kylechui/nvim-surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  -- https://github.com/bkad/CamelCaseMotion
  {
    "bkad/CamelCaseMotion",
    event = "VeryLazy",
    keys = {
      { "w", "<Plug>CamelCaseMotion_w", mode = { "v", "n" }, { silent = true } },
      { "b", "<Plug>CamelCaseMotion_b", mode = { "v", "n" }, { silent = true } },
      { "e", "<Plug>CamelCaseMotion_e", mode = { "v", "n" }, { silent = true } },
    }
  },
}
