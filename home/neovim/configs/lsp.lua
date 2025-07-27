local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.gopls.setup({
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

lspconfig.lua_ls.setup({
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

lspconfig.nil_ls.setup({
	capabilities = capabilities,
})

lspconfig.pyright.setup({
	capabilities = capabilities,
})

lspconfig.ruff.setup({
	capabilities = capabilities,
	init_options = {
		settings = {
			logLevel = "debug",
		},
	},
})
