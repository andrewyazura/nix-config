local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>ff", function()
	fzf.files({ hidden = true })
end, { desc = "file" })

vim.keymap.set("n", "<leader><S-g>", function()
	fzf.live_grep({ search = "" })
end, { desc = "grep files" })

vim.keymap.set("n", "<leader>fls", function()
	fzf.resume()
end, { desc = "resume last search" })
