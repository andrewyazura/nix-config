local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
		python = { "ruff_organize_imports", "ruff_format" },
	},
})

vim.keymap.set("n", "<leader>F", function()
	conform.format({ async = true, lsp_format = "fallback" })
end)
