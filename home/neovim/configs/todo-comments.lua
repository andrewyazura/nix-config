require("todo-comments").setup()

vim.keymap.set("n", "<leader>tl", "<cmd>TodoTelescope<CR>", { desc = "todo in telescope" })
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTrouble<CR>", { desc = "todo in trouble" })
