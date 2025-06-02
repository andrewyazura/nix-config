local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		python = { "black", "isort", "ruff_format" },
		nix = { "nixfmt" },
		lua = { "stylua" },
	},
})

vim.keymap.set("n", "<leader>F", function()
	conform.format({ async = true, lsp_format = "fallback" })
end)
