local trouble = require("trouble")

local float_modes = {
	{ base = "lsp_definitions", key = "d", desc = "definitions" },
	{ base = "lsp_implementations", key = "i", desc = "implementations" },
	{ base = "lsp_references", key = "r", desc = "references" },
	{ base = "lsp_type_definitions", key = "t", desc = "type definitions" },
	{ base = "symbols", desc = "symbols" },
}

local float_config = {
	focus = true,
	win = {
		type = "float",
		relative = "editor",
		size = { width = 0.5, height = 0.6 },
		border = "rounded",
	},
	keys = {
		["<cr>"] = "jump_close",
		["<esc>"] = "close",
	},
}

local modes = {}
for _, m in ipairs(float_modes) do
	modes[m.base .. "_float"] = vim.tbl_extend("force", float_config, { mode = m.base })
end

trouble.setup({
	focus = true,
	follow = false,
	pinned = true,
	win = {
		position = "right",
		size = 60,
	},
	modes = modes,
})

for _, m in ipairs(float_modes) do
	if m.key then
		vim.keymap.set("n", "<leader>gr" .. m.key, "<cmd>Trouble " .. m.base .. " toggle<CR>", { desc = m.desc })
		vim.keymap.set("n", "<leader>gR" .. m.key, "<cmd>Trouble " .. m.base .. "_float toggle<CR>", { desc = m.desc })
	end
end

vim.keymap.set("n", "<leader>gO", "<cmd>Trouble symbols_float toggle<CR>", { desc = "symbols" })

vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "buffer diagnostics" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "location list" })
