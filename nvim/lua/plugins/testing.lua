return {
  {
    -- https://github.com/nvim-neotest/neotest
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "olimorris/neotest-rspec", -- https://github.com/olimorris/neotest-rspec
      "zidhuss/neotest-minitest", -- https://github.com/zidhuss/neotest-minitest
      {
        "stevearc/overseer.nvim", -- https://github.com/stevearc/overseer.nvim
        config = function()
          require("overseer").setup()
        end,
      },
    },
    version = "2.6.1",
    lazy = false,
    -- stylua: ignore
    keys = {
      { "ta", function() require('neotest').run.attach() end,                desc = "Attach" },
      { "tn", function() require('neotest').run.run() end,                   desc = "Run Nearest" },
      { "tl", function() require('neotest').run.run_last() end,              desc = "Run Last" },
      { "tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run File" },
      { "to", function() require('neotest').output.open() end,               desc = "Output" },
      { "tq", function() require('neotest').run.stop() end,                  desc = "Stop" },
      { "tu", function() require('neotest').summary.toggle() end,            desc = "Summary" },
      {
        "ts",
        function()
          local neotest = require("neotest")
          for _, adapter_id in ipairs(neotest.run.adapters()) do
            neotest.run.run({ suite = true, adapter = adapter_id })
          end
        end,
        desc = "Suite",
      },
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      local opts = {
        diagnostic = {
          enabled = true,
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        adapters = {
          -- require("neotest-plenary"),
          require('neotest-rspec'),
          require('neotest-minitest'),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
      require("neotest").setup(opts)
    end
  }
}
