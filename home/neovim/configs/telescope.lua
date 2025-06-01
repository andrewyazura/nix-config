local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files({ hidden = true })
end, { desc = "file" })

vim.keymap.set("n", "<leader><S-g>", builtin.live_grep, { desc = "grep files" })

vim.keymap.set("n", "<leader>fls", builtin.resume, { desc = "search" })
vim.keymap.set("n", "<leader>flp", builtin.pickers, { desc = "pickers" })
