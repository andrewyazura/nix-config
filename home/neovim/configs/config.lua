local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.enable("gopls")
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	capabilities = capabilities,
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
	cmd = { "lua-language-server" },
	capabilities = capabilities,
	filetypes = { "lua" },
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
	cmd = { "nil" },
	capabilities = capabilities,
	filetypes = { "nix" },
})

vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	capabilities = capabilities,
	filetypes = { "python" },
})
