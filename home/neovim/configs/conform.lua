conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    nix = { "nixfmt" },
  },
});

vim.keymap.set("n", "<leader>F", function()
  conform.format({ async = true, lsp_format = "fallback" });
end);
