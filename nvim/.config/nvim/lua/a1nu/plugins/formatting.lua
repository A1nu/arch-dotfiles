return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- JS / TS / Web → Biome
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" }, -- .jsx
				typescriptreact = { "biome" }, -- .tsx
				svelte = { "biome" },
				html = { "biome" },
				css = { "biome" },
				scss = { "biome" },
				less = { "biome" },
				graphql = { "biome" },
				liquid = { "biome" },

				-- Data/markup
				json = { "biome" },
				jsonc = { "biome" }, -- полезно для tsconfig.json
				yaml = { "biome" },
				markdown = { "biome" },

				-- Lua / Python (оставляем как было)
				lua = { "stylua" },
				python = { "isort", "black" },

				-- Go (оставляем как было)
				go = { "goimports", "gofumpt", "golines" },

				-- Java (оставляем как было)
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
