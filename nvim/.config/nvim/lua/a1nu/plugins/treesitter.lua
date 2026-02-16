return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- README: main branch does NOT support lazy-loading
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				-- README default install dir; plugin prepends it to runtimepath for priority
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Install parsers (async). If you want “bootstrapping”, you can :wait().
			ts.install({
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
				-- "dockerfile", -- временно убери, у тебя он сейчас падает при установке
				"editorconfig",
			})

			-- Enable Treesitter highlighting via Neovim API (README)
			vim.api.nvim_create_autocmd("FileType", {
				-- Put the filetypes you care about here
				pattern = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"tsx",
					"html",
					"css",
					"scss",
					"lua",
					"go",
					"bash",
					"json",
					"yaml",
					"xml",
					"markdown",
					"markdown_inline",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})

			-- Indentation: provided by plugin (README shows indentexpr)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"tsx",
				},
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Autotag (works when TS is enabled for buffer)
			require("nvim-ts-autotag").setup()
		end,
	},
}
