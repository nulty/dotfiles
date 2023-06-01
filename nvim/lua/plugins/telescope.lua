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
      { "<leader>f", ":Telescope live_grep<cr>" },
    },
    config = function(config)
      local t = require('telescope.actions').delete_buffer

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
  }
}
