local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

lspconfig.ruff.setup({
	capabilities = capabilities,
	init_options = {
		settings = {},
	},
})
