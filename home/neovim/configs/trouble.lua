local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>Td", "<cmd>Trouble diagnostics toggle<CR>", { desc = "diagnostics" })
vim.keymap.set("n", "<leader>Ts", "<cmd>Trouble symbols toggle<CR>", { desc = "symbols" })
