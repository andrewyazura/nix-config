require("nvim-treesitter.configs").setup({
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	refactor = {
		highlight_definitions = {
			enable = true,
			clear_on_cursor_move = true,
		},
		highlight_current_scope = {
			-- only highlights functions
			enable = false,
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "<leader>R",
			},
		},
		navigation = {
			enable = true,
		},
	},
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
			},
		},
	},
	playground = {
		enable = true,
	},
})

require("treesitter-context").setup({
	enable = true,
})
