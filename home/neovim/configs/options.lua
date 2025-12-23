vim.g.mapleader = " "
vim.g.maplocalleader = ""
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.timeout = true
vim.opt.timeoutlen = 300

vim.opt.conceallevel = 0
vim.opt.termguicolors = true

require("catppuccin").setup({
	transparent_background = true,
	background = {
		light = "latte",
		dark = "mocha",
	},
})

vim.cmd([[colorscheme catppuccin]])

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
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
	filetypes = { "nix" },
})

-- vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		python = {
			analysis = {
				diagnosticMode = "workspace",
				typeCheckingMode = "standard",
				useLibraryCodeForTypes = true,
			},
		},
	},
})

vim.lsp.enable("ty")
vim.lsp.config("ty", {
	filetypes = { "python" },
	settings = {
		ty = {},
	},
})

vim.lsp.enable("typescript_ls")
vim.lsp.config("typescript_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript" },
})
