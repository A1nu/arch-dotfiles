return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- JS / TS / Web
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" }, -- add
				less = { "prettier" }, -- add
				graphql = { "prettier" },
				liquid = { "prettier" },

				-- Data/markup
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },

				-- Lua / Python (unchanged)
				lua = { "stylua" },
				python = { "isort", "black" },

				-- Go (extended)
				-- goimports fixes imports, gofumpt enforces stricter style, golines wraps long lines (optional)
				go = { "goimports", "gofumpt", "golines" },

				-- Java (new)
				-- Requires google-java-format (JDK ≥ 17) or falls back to LSP if not found
				java = { "google-java-format", lsp_format = "fallback" },

				-- Shell (new)
				-- note: filetype is "sh" even for Bash files in most setups
				sh = { "shfmt" },

				-- C/C++ (new)
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
