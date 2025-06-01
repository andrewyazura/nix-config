local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>Td", "<cmd>Trouble diagnostics toggle<CR>", { desc = "diagnostics" })
