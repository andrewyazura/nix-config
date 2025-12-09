local fzf = require("fzf-lua")
local fzf_config = require("fzf-lua.config")
local trouble_fzf = require("trouble.sources.fzf")

fzf_config.defaults.actions.files["ctrl-t"] = trouble_fzf.actions.open

vim.keymap.set("n", "<leader>ff", function()
	fzf.files({ hidden = true })
end, { desc = "file" })

vim.keymap.set("n", "<leader>fls", function()
	fzf.resume()
end, { desc = "resume last search" })

vim.keymap.set("n", "<leader><S-g>", function()
	fzf.live_grep({ search = "" })
end, { desc = "grep files" })
