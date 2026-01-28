return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		symbol_in_winbar = {
			enable = true,
			separator = " > ",
			hide_keyword = true,
			show_file = true,
			color_mode = true,
		},
		lightbulb = {
			virtual_text = false,
		},
	},
}
