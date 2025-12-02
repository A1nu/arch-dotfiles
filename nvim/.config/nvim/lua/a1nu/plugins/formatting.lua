return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local util = require("conform.util")

		conform.setup({
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" }, -- .jsx
				typescriptreact = { "biome" }, -- .tsx
				json = { "biome" },
				jsonc = { "biome" }, -- tsconfig
				css = { "biome" },
				graphql = { "biome" },

				svelte = { "prettierd" },
				html = { "prettierd" },
				scss = { "prettierd" },
				less = { "prettierd" },
				liquid = { "prettierd" },

				-- Markdown / YAML
				markdown = { "prettierd", "markdownlint" },
				yaml = { "prettierd" },

				-- Lua / Python
				lua = { "stylua" },
				python = { "isort", "black" },

				-- Go
				go = { "goimports", "gofumpt", "golines" },

				-- Java
				java = { "google-java-format", lsp_format = "fallback" },

				-- Shell
				sh = { "shfmt" },

				-- C/C++
				c = { "clang-format" },
				cpp = { "clang-format" },
			},

			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
