function setup_obsidian(vault_path)
	require("obsidian").setup({
		workspaces = { { name = "vault", path = vault_path } },
		daily_notes = { folder = "daily" },
		picker = { name = "fzf-lua" },
		legacy_commands = false,
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})

vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<CR>", { desc = "quick switch" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<CR>", { desc = "new note" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian today<CR>", { desc = "daily note" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<CR>", { desc = "search" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", { desc = "backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<CR>", { desc = "links" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian tags<CR>", { desc = "tags" })
