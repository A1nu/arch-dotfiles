return {
	{
		"nvimdev/hlsearch.nvim",
		event = "BufReadPost",
		config = function()
			require("hlsearch").setup()
		end,
	},
}
