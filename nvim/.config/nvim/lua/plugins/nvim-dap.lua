return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "igorlfs/nvim-dap-view",
    "leoluz/nvim-dap-go",
  },
  config = function()
    require("config.dap").setup()
  end,
  keys = function()
    local function dap(fn)
      return function() require("dap")[fn]() end
    end
    return {
      {
        "<leader>d",
        group = "Debug",
        { "<leader>db", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
        {
          "<leader>dB",
          function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
          desc = "Conditional breakpoint",
        },
        { "<leader>dc", dap("continue"),     desc = "Start / continue" },
        { "<leader>dC", dap("run_to_cursor"), desc = "Run to cursor" },
        { "<leader>dl", dap("run_last"),     desc = "Rerun last session" },
        { "<leader>dn", dap("step_over"),    desc = "Step over" },
        { "<leader>di", dap("step_into"),    desc = "Step into" },
        { "<leader>do", dap("step_out"),     desc = "Step out" },
        { "<leader>dq", dap("terminate"),    desc = "Terminate" },
        { "<leader>dv", function() require("dap-view").toggle() end, desc = "Toggle view" },
        { "<leader>dw", function() require("dap-view").add_expr() end, desc = "Watch expression" },
        { "<leader>dt", function() require("dap-go").debug_test() end, desc = "Debug Go test" },
        { "<leader>dT", function() require("dap-go").debug_last_test() end, desc = "Debug last Go test" },
      },
      -- Stepping is the hot path; a leader chord per step gets old fast. F5
      -- stays :restart.
      { "<F9>",  dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
      { "<F10>", dap("step_over"),         desc = "Step over" },
      { "<F11>", dap("step_into"),         desc = "Step into" },
      { "<F12>", dap("step_out"),          desc = "Step out" },
    }
  end,
}
