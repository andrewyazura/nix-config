vim.filetype.add({
	extension = {
		zsh = "sh",
	},
	filename = {
		[".zshrc"] = "sh",
		[".zshenv"] = "sh",
		[".zprofile"] = "sh",
	},
})

require("nvim-treesitter").setup()
require("treesitter-context").setup({ enable = true })

local ts_indent_disabled = { kotlin = true }

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
			if not ts_indent_disabled[args.match] then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		include_surrounding_whitespace = false,
	},
	move = {
		set_jumps = true,
	},
})

-- selections: function
vim.keymap.set({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end, { desc = "around function" })

vim.keymap.set({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end, { desc = "inside function" })

-- selections: class
vim.keymap.set({ "x", "o" }, "ac", function()
	select.select_textobject("@class.outer", "textobjects")
end, { desc = "around class" })

vim.keymap.set({ "x", "o" }, "ic", function()
	select.select_textobject("@class.inner", "textobjects")
end, { desc = "inside class" })

-- selections: argument/parameter
vim.keymap.set({ "x", "o" }, "aa", function()
	select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "around argument" })

vim.keymap.set({ "x", "o" }, "ia", function()
	select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "inside argument" })

-- movement: functions
vim.keymap.set({ "n", "x", "o" }, "]m", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

vim.keymap.set({ "n", "x", "o" }, "[m", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous function start" })

vim.keymap.set({ "n", "x", "o" }, "]M", function()
	move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })

vim.keymap.set({ "n", "x", "o" }, "[M", function()
	move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Previous function end" })

-- movement: classes
vim.keymap.set({ "n", "x", "o" }, "]]", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })

vim.keymap.set({ "n", "x", "o" }, "[[", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Previous class start" })

-- swap parameters
vim.keymap.set("n", "<leader>a", function()
	swap.swap_next("@parameter.inner")
end, { desc = "Swap with next parameter" })

vim.keymap.set("n", "<leader>A", function()
	swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous parameter" })
