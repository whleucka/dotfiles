local M = {}

local function prompt_program()
  return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
end

local function prompt_args()
  return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
end

function M.setup()
  local dap = require("dap")

  -- C, C++ and Rust through lldb-dap, which ships with the lldb package. Build
  -- with -g (CMake: -DCMAKE_BUILD_TYPE=Debug) or there is nothing to step.
  dap.adapters.lldb = { type = "executable", command = "lldb-dap", name = "lldb" }
  local lldb = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = prompt_program,
      args = prompt_args,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "Attach to process",
      type = "lldb",
      request = "attach",
      pid = require("dap.utils").pick_process,
    },
  }
  dap.configurations.c = lldb
  dap.configurations.cpp = lldb
  dap.configurations.rust = lldb

  -- Go through delve's native DAP mode. Registers the adapter plus "Debug",
  -- "Debug test", "Debug (go.mod)" etc. configurations.
  require("dap-go").setup()

  -- Opens on session start and closes when it ends. Values are drawn inline
  -- at the end of each line while stopped.
  require("dap-view").setup({
    auto_toggle = true,
    virtual_text = { enabled = true, position = "eol" },
  })

  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
  vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })
end

return M
