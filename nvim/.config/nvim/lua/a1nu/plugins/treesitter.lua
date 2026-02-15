return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.config")
			treesitter.setup({
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				ensure_installed = {
					"tsx",
					"yaml",
					"html",
					"markdown",
					"markdown_inline",
					"gitignore",
					"java",
					"javascript",
					"typescript",
					"css",
					"lua",
					"bash",
					"go",
					"json",
					"xml",
					"query",
					"vim",
					"vimdoc",
					"c",
					"regex",
					"scss",
					"dockerfile",
					"editorconfig",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},
}
