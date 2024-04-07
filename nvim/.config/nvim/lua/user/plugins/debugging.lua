return {
  "nvim-neotest/nvim-nio",
  -- See this https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- TODO(alvaro): It is recommended to give `debugpy` its own virtual env
      -- TODO(alvaro): DAP Python offers python specific methods that could be useful
      dap_python = require "dap-python"
      dap_python.setup(vim.fn.exepath "python3")
      dap_python.test_runner = "pytest"
    end,
    keys = {
      {
        "<Leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<Leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<Leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<Leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<Leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<Leader>dB",
        function()
          require("dap").set_breakpoint()
        end,
        desc = "DAP Set Breakpoint",
      },
      {
        "<Leader>dp",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
        end,
        desc = "DAP Set Breakpoint with log point message",
      },
      {
        "<Leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "DAP Toggle REPL",
      },
      {
        "<Leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP Run last target",
      },
      {
        "<Leader>dq",
        function()
          -- require("dap").disconnect()
          -- require("dap").close()
          require("dap").terminate()
        end,
        desc = "DAP close",
      },
      {
        "<Leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "DAP Show Hover Widget",
        mode = { "n", "v" },
      },
      {
        "<Leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
        desc = "DAP Show Preview Widget",
        mode = { "n", "v" },
      },
      {
        "<Leader>df",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.frames)
        end,
        desc = "DAP Show Frames Widget",
      },
      {
        "<Leader>ds",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP Show Scopes Widget",
      },
      {
        "<Leader>dC",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "DAP Clear Breakpoints",
      },
      {
        "<Leader>dk",
        function()
          require("dap").up()
        end,
      },
      {
        "<Leader>dj",
        function()
          require("dap").down()
        end,
      },
    },
  },
  -- TODO(alvaro): This has a `neodev` plugin ready
  -- https://github.com/folke/neodev.nvim
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      -- XXX(alvaro): Port the dapui config here
      local dap = require "dap"
      local dap_ui = require "dapui"
      dap_ui.setup()

      -- Use nvim-dap events to automatically open the UI
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      {
        "<Leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "DAP UI Evaluate Expression",
      },
      {
        "<Leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "DAP UI Evaluate selected expression",
        mode = "v",
      },
      {
        "<Leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI Toggle",
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",
    },
  },
}
