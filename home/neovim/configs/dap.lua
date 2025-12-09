local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

dapui.setup()
daptext.setup()

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

dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			local cwd = vim.fn.getcwd()

			if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return "/usr/bin/env python3"
			end
		end,
	},
}
