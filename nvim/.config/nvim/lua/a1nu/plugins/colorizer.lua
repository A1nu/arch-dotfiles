return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {},
	config = function()
		require("colorizer").setup({
			filetypes = { "*" }, -- enable for all files
			user_default_options = {
				names = false, -- "Blue", "Red", etc
			},
		})
	end,
}
