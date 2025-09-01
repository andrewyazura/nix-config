require("todo-comments").setup()

vim.keymap.set("n", "<leader>Tt", "<cmd>TodoTrouble<CR>", { desc = "todo in trouble" })
vim.keymap.set("n", "<leader>Tl", "<cmd>TodoTelescope<CR>", { desc = "todo in telescope" })
