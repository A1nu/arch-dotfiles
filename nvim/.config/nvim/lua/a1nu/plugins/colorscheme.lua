return {
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.sonokai_style = "andromeda"
			vim.g.sonokai_enable_italic = true
			vim.g.sonokai_transparent_background = 1
			vim.cmd.colorscheme("sonokai")
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#AF868B", bold = true })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#86AFAA" })
		end,
	},
}
