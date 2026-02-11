local trouble = require("trouble")

trouble.setup({
	focus = true,
	follow = false,
	pinned = true,
})

-- mirroring the default lsp binds
vim.keymap.set("n", "<leader>gO", "<cmd>Trouble symbols toggle<CR>", { desc = "symbols" })
vim.keymap.set("n", "<leader>grd", "<cmd>Trouble lsp_definitions toggle<CR>", { desc = "definitions" })
vim.keymap.set("n", "<leader>gri", "<cmd>Trouble lsp_implementations toggle<CR>", { desc = "implementations" })
vim.keymap.set("n", "<leader>grr", "<cmd>Trouble lsp_references toggle<CR>", { desc = "references" })
vim.keymap.set("n", "<leader>grt", "<cmd>Trouble lsp_type_definitions toggle<CR>", { desc = "type definitions" })

-- trouble.nvim exclusive
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "buffer diagnostics" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "location list" })
