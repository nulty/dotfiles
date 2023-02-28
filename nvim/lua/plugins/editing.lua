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
  { 'AndrewRadev/switch.vim', event = "VeryLazy" }
}
