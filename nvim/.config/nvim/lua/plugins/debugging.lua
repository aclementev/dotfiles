return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "mfussenegger/nvim-dap-python" },
      { "leoluz/nvim-dap-go" },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      { "theHamsta/nvim-dap-virtual-text" },
    },
    config = function()
      local dap = require("dap")

      -- Python via debugpy (managed by uv)
      require("dap-python").setup("uv")

      -- Go via delve (must be in PATH)
      require("dap-go").setup()

      -- Rust via codelldb
      local codelldb_path = vim.fn.expand("~/.local/share/codelldb/extension/adapter/codelldb")
      dap.adapters.codelldb = {
        type = "executable",
        command = codelldb_path,
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- DAP UI: auto open/close on debug sessions
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Inline virtual text showing variable values
      require("nvim-dap-virtual-text").setup({
        virt_text_pos = "inline",
      })
    end,
    keys = {
      -- Session
      { "<Leader>dc", function() require("dap").continue() end, desc = "DAP: Continue" },
      { "<Leader>dn", function() require("dap").step_over() end, desc = "DAP: Step over" },
      { "<Leader>di", function() require("dap").step_into() end, desc = "DAP: Step into" },
      { "<Leader>do", function() require("dap").step_out() end, desc = "DAP: Step out" },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "DAP: Run last" },
      { "<Leader>dq", function() require("dap").terminate() end, desc = "DAP: Terminate" },
      -- Stack navigation
      { "<Leader>dk", function() require("dap").up() end, desc = "DAP: Up in stack" },
      { "<Leader>dj", function() require("dap").down() end, desc = "DAP: Down in stack" },
      -- Breakpoints
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
      { "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: Conditional breakpoint" },
      { "<Leader>dp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, desc = "DAP: Log point" },
      { "<Leader>dC", function() require("dap").clear_breakpoints() end, desc = "DAP: Clear breakpoints" },
      -- Inspection
      { "<Leader>dr", function() require("dap").repl.toggle() end, desc = "DAP: Toggle REPL" },
      { "<Leader>dh", function() require("dap.ui.widgets").hover() end, desc = "DAP: Hover", mode = { "n", "v" } },
      {
        "<Leader>df",
        function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.frames)
        end,
        desc = "DAP: Frames",
      },
      {
        "<Leader>ds",
        function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.scopes)
        end,
        desc = "DAP: Scopes",
      },
      -- DAP UI
      { "<Leader>du", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
      { "<Leader>de", function() require("dapui").eval() end, desc = "DAP: Eval", mode = { "n", "v" } },
    },
  },
}
