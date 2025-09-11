return {
	"RRethy/vim-illuminate",
	event = "VeryLazy",
	opts = {
		providers = { "lsp", "treesitter", "regex" },
		delay = 100,
		filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
		under_cursor = true,
		large_file_cutoff = 10000,
	},
	config = function(_, opts)
		require("illuminate").configure(opts)
		-- Optional: nicer highlight (uses your colorscheme groups)
		vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
	end,
}
