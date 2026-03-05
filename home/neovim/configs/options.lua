vim.g.mapleader = " "
vim.g.maplocalleader = ""

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.timeout = true
vim.opt.timeoutlen = 300

vim.api.nvim_create_autocmd("FileType", {
	pattern = "kotlin",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

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

vim.lsp.enable("ruff")
vim.lsp.config("ruff", {
	cmd = { "ruff", "server", "--preview" },
	filetypes = { "python" },
})

vim.lsp.enable("ty")
vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	settings = {
		ty = {
			diagnosticMode = "openFilesOnly",
		},
	},
})

vim.lsp.enable("typescript_ls")
vim.lsp.config("typescript_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript" },
})

vim.lsp.enable("kotlin_ls")
vim.lsp.config("kotlin_ls", {
	cmd = { "/opt/homebrew/bin/kotlin-lsp", "--stdio" },
	filetypes = { "kotlin" },
	root_markers = { "settings.gradle.kts", "settings.gradle" },
})

-- Strip textDocument.version from workspace edits to work around kotlin-lsp
-- returning stale version numbers, causing Neovim to reject the edit with
-- "Buffer ... newer than edits."
local rename_handler = vim.lsp.handlers["textDocument/rename"]
vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if client and client.name == "kotlin_ls" and result and result.documentChanges then
		for _, change in ipairs(result.documentChanges) do
			if change.textDocument then
				change.textDocument.version = nil
			end
		end
	end
	return rename_handler(err, result, ctx, config)
end

vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition()" })
vim.keymap.set("n", "grl", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 2,
	},
	signs = true,
	underline = true,
	severity_sort = true,
})
