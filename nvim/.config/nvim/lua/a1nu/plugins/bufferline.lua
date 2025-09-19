return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "slant",
			show_buffer_close_icons = false,
			diagnostics = "nvim_lsp",
			show_close_icon = false,
			numbers = function(opts)
				return string.format("%s", opts.ordinal) -- или opts.id / opts.ordinal
			end,
		},
	},
}
