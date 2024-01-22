return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<leader>t", ":Telescope find_files<cr>" },
      { "<leader>b", ":Telescope buffers<cr>" },
      { "<leader>m", ":Telescope keymaps<cr>" },
      { "<leader>f", ":Telescope live_grep<cr>" },
      { "<leader>g", ":Telescope dir live_grep<cr>" },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            n = {
              ['<c-d>'] = require('telescope.actions').delete_buffer
            },
            i = {
              ['<c-d>'] = require('telescope.actions').delete_buffer
            }
          }
        }
      })
    end
  },
  {
    "princejoogie/dir-telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("dir-telescope").setup({
        -- these are the default options set
        hidden = true,
        no_ignore = true,
        show_preview = true,
      })
      require("telescope").load_extension("dir")
    end
  }
}
