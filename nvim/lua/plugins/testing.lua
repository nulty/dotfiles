return {
  {
    -- https://github.com/nvim-neotest/neotest
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/nvim-nio",
      "olimorris/neotest-rspec",    -- https://github.com/olimorris/neotest-rspec
      {
        "zidhuss/neotest-minitest", -- https://github.com/zidhuss/neotest-minitest
        confit = function(_config)
          require('neotest-minitest').setup({
            test_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rails",
                "test",
              })
            end
          })
        end
      },
      {
        "stevearc/overseer.nvim", -- https://github.com/stevearc/overseer.nvim
        version = "1.3.0",
        config = function()
          require("overseer").setup()
        end,
      },
    },
    version = "4.4.1",
    lazy = false,
    -- stylua: ignore
    keys = {
      { "]t", function() require('neotest').jump.next() end,                 desc = "Next test" },
      { "[t", function() require('neotest').jump.prev() end,                 desc = "Prev test" },
      { "ta", function() require('neotest').run.attach() end,                desc = "Attach" },
      { "tn", function() require('neotest').run.run() end,                   desc = "Run Nearest" },
      { "tl", function() require('neotest').run.run_last() end,              desc = "Run Last" },
      { "tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run File" },
      { "tp", function() require('neotest').output_panel.toggle() end,       desc = "Output panel" },
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

      -- vim.cmd([[
      --   hi default NeotestPassed ctermfg=Green guifg=#96F291
      --   hi default NeotestFailed ctermfg=Red guifg=#F70067
      --   hi default NeotestRunning ctermfg=Yellow guifg=#FFEC63
      --   hi default NeotestSkipped ctermfg=Cyan guifg=#00f1f5
      --   hi default link NeotestTest Normal
      --   hi default NeotestNamespace ctermfg=Magenta guifg=#D484FF
      --   hi default NeotestFocused gui=bold,underline cterm=bold,underline
      --   hi default NeotestFile ctermfg=Cyan guifg=#00f1f5
      --   hi default NeotestDir ctermfg=Cyan guifg=#00f1f5
      --   hi default NeotestIndent ctermfg=Grey guifg=#8B8B8B
      --   hi default NeotestExpandMarker ctermfg=Grey guifg=#8094b4
      --   hi default NeotestAdapterName ctermfg=Red guifg=#F70067
      --   hi default NeotestWinSelect ctermfg=Cyan guifg=#00f1f5 gui=bold
      --   hi default NeotestMarked ctermfg=Brown guifg=#F79000 gui=bold
      --   hi default NeotestTarget ctermfg=Red guifg=#F70067
      --   hi default NeotestWatching ctermfg=Yellow guifg=#FFEC63
      --   hi default link NeotestUnknown Normal
      -- ]])
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

      vim.cmd([[hi NeotestDir guifg=#ffffff]])
    end
  }
}
