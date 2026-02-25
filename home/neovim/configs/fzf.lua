local fzf = require("fzf-lua")
local fzf_config = require("fzf-lua.config")
local trouble_fzf = require("trouble.sources.fzf")

fzf_config.defaults.actions.files["ctrl-t"] = trouble_fzf.actions.open

vim.keymap.set("n", "<leader>ff", function()
	fzf.files({ hidden = true })
end, { desc = "file" })

vim.keymap.set("n", "<leader>fls", function()
	fzf.resume()
end, { desc = "last search" })

vim.keymap.set("n", "<leader><S-g>", function()
	fzf.live_grep({ search = "" })
end, { desc = "with grep" })

vim.keymap.set("n", "<leader>fb", function()
	fzf.buffers({ sort_lastused = true })
end, { desc = "buffers" })

vim.keymap.set("n", "<leader>fs", function()
	fzf.lsp_workspace_symbols()
end, { desc = "workspace symbols" })

vim.keymap.set("n", "<leader>ci", function()
	fzf.lsp_incoming_calls()
end, { desc = "incoming calls" })

vim.keymap.set("n", "<leader>co", function()
	fzf.lsp_outgoing_calls()
end, { desc = "outgoing calls" })
