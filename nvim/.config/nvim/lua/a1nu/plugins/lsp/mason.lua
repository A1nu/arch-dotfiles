return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"mfussenegger/nvim-lint",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				-- JS / TS / TSX
				"ts_ls", -- TypeScript/JavaScript
				-- Web stack
				"html", -- HTML
				"cssls", -- CSS/SCSS/LESS
				"emmet_language_server", -- Emmet
				-- Markup / data
				-- "jsonls", -- JSON
				"yamlls", -- YAML
				"lemminx", -- XML
				"marksman", -- Markdown
				-- General languages
				"lua_ls", -- Lua
				"bashls", -- Bash/sh
				"clangd", -- C/C++
				"vimls", -- Vimscript
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Biome вместо prettier/eslint
				"biome",

				-- остальные форматтеры/линтеры
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"shfmt",
				"clang-format",
				"htmlhint",
				"yamllint",
				"markdownlint",
				"shellcheck",
				"checkstyle",
				"editorconfig-checker",
				"gopls",
				"golangci-lint",
			},
		})
	end,
}
