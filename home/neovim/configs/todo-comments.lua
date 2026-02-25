require("todo-comments").setup()

vim.keymap.set("n", "<leader>Td", "<cmd>TodoTrouble<CR>", { desc = "todo in trouble" })
vim.keymap.set("n", "<leader>Tf", "<cmd>TodoFzfLua<CR>", { desc = "todo in fzf" })
