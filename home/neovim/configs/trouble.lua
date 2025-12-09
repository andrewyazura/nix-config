local trouble = require("trouble")

trouble.setup({
	win = { position = "right", size = 0.4 },
})

vim.keymap.set("n", "<leader>trd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "buffer diagnostics" })
vim.keymap.set("n", "<leader>trD", "<cmd>Trouble diagnostics toggle<CR>", { desc = "project diagnostics" })

vim.keymap.set("n", "<leader>trs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "symbols" })
vim.keymap.set("n", "<leader>trr", "<cmd>Trouble lsp_references toggle<CR>", { desc = "lsp references" })

vim.keymap.set("n", "<leader>trq", "<cmd>Trouble qflist toggle<CR>", { desc = "quickfix List" })
vim.keymap.set("n", "<leader>trl", "<cmd>Trouble loclist toggle<CR>", { desc = "location List" })
