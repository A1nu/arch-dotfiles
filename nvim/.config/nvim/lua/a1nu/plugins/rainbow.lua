return {
	"HiPhish/rainbow-delimiters.nvim",
	git = { submodules = false },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		-- Example: customize highlight groups
		vim.g.rainbow_delimiters = {
			-- Buffers with no treesitter parser (alpha dashboard, snacks notifier
			-- windows, etc.) make get_parser return nil on the treesitter `main`
			-- branch, which crashes rainbow-delimiters on attach. Only attach when a
			-- real parser exists for the buffer.
			condition = function(bufnr)
				return vim.treesitter.get_parser(bufnr, nil, { error = false }) ~= nil
			end,
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		}
	end,
}
