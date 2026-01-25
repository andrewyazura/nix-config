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
	{ "<leader>f", group = "+find" },
	{ "<leader>g", group = "+goto with trouble)" },
	{ "<leader>gr", group = "+references" },
	{ "<leader>x", group = "+trouble" },
	{ "<leader>w", proxy = "<C-w>", group = "+windows" },
})
