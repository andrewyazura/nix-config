local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>trd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "diagnostics" })
vim.keymap.set("n", "<leader>trs", "<cmd>Trouble symbols toggle<CR>", { desc = "symbols" })
