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

vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
