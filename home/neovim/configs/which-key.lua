local wk = require("which-key")

wk.setup({
	delay = 100,
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
})

wk.add({
	{ "<leader>F", desc = "format buffer" },
	{ "<leader>T", group = "+todo" },
	{ "<leader>c", group = "+calls" },
	{ "<leader>f", group = "+find" },
	{ "<leader>gr", group = "+references" },
	{ "<leader>gR", group = "+references (float)" },
	{ "<leader>q", group = "+session" },
	{ "<leader>t", group = "+test" },
	{ "<leader>u", desc = "toggle undo tree" },
	{ "<leader>w", proxy = "<C-w>", group = "+windows" },
	{ "<leader>x", group = "+trouble" },
})
