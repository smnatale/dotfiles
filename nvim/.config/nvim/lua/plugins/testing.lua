return {
  "nvim-neotest/neotest",
  keys = {
    { "<leader>mr", "<cmd>Neotest run<cr>" },
    { "<leader>ms", "<cmd>Neotest summary<cr>" },
    { "<leader>mo", "<cmd>Neotest output<cr>" },
    { "<leader>mp", "<cmd>Neotest output-panel<cr>" },
    {
      "<leader>md",
      function()
        require("neotest").run.run({ suite = false, strategy = "dap" })
      end,
    },
  },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "fredrikaverpil/neotest-golang",
      build = function()
        vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
      end,
    },
  },
  config = function()
    require("neotest").setup({
      ---@diagnostic disable-next-line: missing-fields
      adapters = {
        require("neotest-golang")({
          runner = "gotestsum",
        }),
      },
    })
  end,
}
