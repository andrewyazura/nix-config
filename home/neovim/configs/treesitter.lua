require("nvim-treesitter").setup({
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
})

vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, { desc = "around function" })

vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, { desc = "inner function" })

vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, { desc = "around class" })

vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { desc = "inner class" })

vim.keymap.set({ "x", "o" }, "aa", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end, { desc = "around argument" })

vim.keymap.set({ "x", "o" }, "ia", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end, { desc = "inner argument" })

vim.keymap.set({ "n", "x", "o" }, "]f", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end, { desc = "next function" })

vim.keymap.set({ "n", "x", "o" }, "[f", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "prev function" })

require("treesitter-context").setup({
	enable = true,
})
