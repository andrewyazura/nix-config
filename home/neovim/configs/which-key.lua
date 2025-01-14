local wk = require("which-key")

wk.setup()
wk.add({
	{ "<leader>f", group = "+find" },
	{ "<leader>fl", group = "+find last" },
	{ "<leader>g", group = "+go to" },
	{ "<leader>gd", desc = "definition" },
	{ "<leader>gn", desc = "next usage" },
	{ "<leader>gp", desc = "prev usage" },
	{ "<leader>h", group = "+harpoon" },
	{ "<leader>w", proxy = "<C-w>", group = "+windows" },
	{ "<leader>F", desc = "format buffer" },
})
