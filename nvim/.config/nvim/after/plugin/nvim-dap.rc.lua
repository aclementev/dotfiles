local setup, dap = pcall(require, "dap")
if not setup then
	return
end

local nmap = function(mapping, fn)
	vim.keymap.set("n", mapping, fn, { silent = true })
end
-- Setup the mappings
nmap("<Leader>dc", dap.continue)
nmap("<Leader>dn", dap.step_over)
nmap("<Leader>di", dap.step_into)
nmap("<Leader>do", dap.step_out)
nmap("<Leader>dk", dap.up)
nmap("<Leader>dj", dap.down)
nmap("<Leader>db", dap.toggle_breakpoint)
nmap("<Leader>dC", dap.clear_breakpoints)
nmap("<Leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
nmap("<Leader>dp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
nmap("<Leader>dr", dap.repl.toggle)
nmap("<Leader>dl", dap.run_last)
nmap("<Leader>dL", dap.launch)
nmap("<Leader>dq", function()
	dap.disconnect()
	dap.close()
    -- For some reason the listener below does not trigger when we call this
    -- so we do it here manually
    require('dapui').close()
end)

-- DapUI
local setup_ui, dap_ui = pcall(require, "dapui")
if setup_ui then
	dap_ui.setup({})

	-- Automatically trigger the UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
        dap_ui.open()
    end
	dap.listeners.before.event_terminated["dapui_config"] = function()
        dap_ui.close()
    end
	dap.listeners.before.event_exited["dapui_config"] = function()
        dap_ui.close()
    end

	-- Mappings
	nmap("<Leader>de", dap_ui.eval)
	nmap("<Leader>du", dap_ui.toggle)
	vim.keymap.set("v", "<Leader>de", dap_ui.eval, { silent = true, buffer = true })
end

-- Language specific setup

-- Python
local setup_py, dap_python = pcall(require, "dap-python")
if setup_py then
	-- TODO(alvaro): It is recommended to give `debugpy` its own virtual env
	dap_python.setup(vim.fn.exepath("python3"))
	dap_python.test_runner = "pytest"
	-- TODO(alvaro): DAP Python offers python specific methods that could be useful
end
