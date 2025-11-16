require("todo-comments").setup()

vim.keymap.set("n", "<leader>tdt", "<cmd>TodoTelescope<CR>", { desc = "todo in telescope" })
vim.keymap.set("n", "<leader>tdt", "<cmd>TodoTrouble<CR>", { desc = "todo in trouble" })
