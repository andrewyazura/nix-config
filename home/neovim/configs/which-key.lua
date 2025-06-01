local wk = require("which-key")

wk.setup()
wk.add({
	{ "<leader>w", proxy = "<C-w>", group = "+windows" },
	{ "<leader>f", group = "+find" },
	{ "<leader>fl", group = "+find last" },
	{ "<leader>g", group = "+go to" },
	{ "<leader>gd", desc = "definition" },
	{ "<leader>F", desc = "format buffer" },
	{ "<leader>R", desc = "smart rename" },
	{ "<leader>T", group = "+trouble" },
})
