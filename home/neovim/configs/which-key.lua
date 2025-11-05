local wk = require("which-key")

wk.setup()
wk.add({
	{ "<leader>F", desc = "format buffer" },
	{ "<leader>R", desc = "smart rename" },
	{ "<leader>f", group = "+find" },
	{ "<leader>fl", group = "+find last" },
	{ "<leader>g", group = "+go to" },
	{ "<leader>gd", desc = "definition" },
	{ "<leader>t", group = "+toolbar" },
	{ "<leader>w", proxy = "<C-w>", group = "+windows" },
})
