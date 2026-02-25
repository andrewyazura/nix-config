local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		json = { "jq" },
		kotlin = { "ktfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
		python = { "ruff_organize_imports", "ruff_format" },
		typescript = { "prettier" },
	},
})

vim.keymap.set("n", "<leader>F", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
