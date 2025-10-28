require("avante").setup({
	provider = "claude",
	providers = {
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-sonnet-4-5-20250929",
			timeout = 30000,
			extra_request_body = {
				temperature = 0.0,
				max_tokens = 32768,
			},
		},
	},
})
