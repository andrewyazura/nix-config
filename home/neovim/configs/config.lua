local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.enable("gopls")
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			usePlaceholders = false,
			completeFunctionCalls = false,
		},
	},
})

vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
				},
			},
		},
	},
})

vim.lsp.enable("nil_ls")
vim.lsp.config("nil_ls", {
	capabilities = capabilities,
})

vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
	capabilities = capabilities,
})

vim.lsp.enable("ruff")
vim.lsp.config("ruff", {
	capabilities = capabilities,
	init_options = {
		settings = {
			logLevel = "debug",
		},
	},
})
