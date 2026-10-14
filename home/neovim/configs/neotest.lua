local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-python")({
			runner = "pytest",
		}),
	},
})

vim.keymap.set("n", "<leader>tt", function()
	neotest.run.run()
end, { desc = "run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "run file" })

vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "toggle summary" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({ enter = true })
end, { desc = "show output" })

vim.keymap.set("n", "<leader>tO", function()
	neotest.output_panel.toggle()
end, { desc = "toggle output panel" })

vim.keymap.set("n", "<leader>tw", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "toggle watch" })

vim.keymap.set("n", "<leader>td", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "debug nearest test" })

vim.keymap.set("n", "[t", function()
	neotest.jump.prev({ status = "failed" })
end, { desc = "prev failed test" })

vim.keymap.set("n", "]t", function()
	neotest.jump.next({ status = "failed" })
end, { desc = "next failed test" })
