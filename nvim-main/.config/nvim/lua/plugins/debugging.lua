return {
  "igorlfs/nvim-dap-view",
  dependencies = {
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
  },
  keys = {
    { "<leader>dt", "<cmd>DapViewToggle<cr>" },
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>" },
    { "<leader>dc", "<cmd>DapContinue<cr>" },
    { "<leader>dw", "<cmd>DapViewWatch<cr>" },
  },
  config = function()
    require("nvim-dap-virtual-text").setup()
  end,
}
