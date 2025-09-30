return {
	"HiPhish/rainbow-delimiters.nvim",
	git = { submodules = false },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		-- Example: customize highlight groups
		vim.g.rainbow_delimiters = {
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
