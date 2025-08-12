return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
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
			-- list of servers for mason to install
			ensure_installed = {
				-- JS / TS / TSX
				"ts_ls", -- TypeScript/JavaScript (supersedes tsserver)  -- jsx, tsx too
				"eslint", -- LSP for ESLint (diagnostics/code-actions)
				"tailwindcss", -- Tailwind CSS IntelliSense (optional but common)
				-- Web stack
				"html", -- HTML
				"cssls", -- CSS/SCSS/LESS supported by cssls
				"emmet_language_server", -- Emmet for HTML/CSS/JSX/TSX (optional)
				-- Markup / data
				"jsonls", -- JSON
				"yamlls", -- YAML
				"lemminx", -- XML
				"marksman", -- Markdown LSP
				-- General languages
				"lua_ls", -- Lua
				"bashls", -- Bash/sh
				"gopls", -- Go
				"jdtls", -- Java
				"clangd", -- C/C++ (covers your Treesitter `c`)
				"vimls", -- Vimscript (for `vim` filetype)
				"basedpyright", -- or "pyright" (pick one)
				"ruff",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"goimports",
				"gofumpt",
				"golines",
				"google-java-format",
				"shfmt",
				"clang-format",
				"eslint_d",
				"htmlhint",
				"jsonlint",
				"yamllint",
				"markdownlint",
				"shellcheck",
				"golangci-lint",
				"checkstyle",
				"hadolint",
				"editorconfig-checker",
				"pylint",
			},
		})
	end,
}
