local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle<CR>", { desc = "diagnostics" })
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle<CR>", { desc = "symbols" })
