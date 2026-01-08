return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		useLspFoldsWithTree = true,

		pauseFoldsOnSearch = true,

		foldtext = {
			enabled = true,
			padding = 3,
			lineCount = { template = "%d lines", hlgroup = "Comment" },
			diagnosticsCount = true,
			gitsignsCount = true,
		},

		autoFold = {
			enabled = true,
			kinds = { "comment", "imports" },
		},

		foldKeymaps = {
			setup = false,
			hOnlyOpensOnFirstColumn = false,
		},
	},
	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
}
