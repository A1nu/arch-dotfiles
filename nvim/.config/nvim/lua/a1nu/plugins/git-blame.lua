return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- Disable all inline / virtual blame
			current_line_blame = false,
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "│" },
				topdelete = { text = "│" },
				changedelete = { text = "│" },
			},
		},
		keys = {
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Git blame (last commit + diff)",
			},
		},
	},
}
