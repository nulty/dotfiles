return {
  {
    "nvim-telescope/telescope.nvim",
    lazyb= true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<leader>t", ":Telescope find_files<cr>" },
      { "<leader>b", ":Telescope buffers<cr>" },
      { "<leader>m", ":Telescope keymaps<cr>" },
      { "<leader>f", ":Telescope live_grep<cr>" },
    }
  }
}
