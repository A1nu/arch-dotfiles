return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- 🔧 Define Biome linter
		lint.linters.biome = {
			cmd = "biome",
			args = { "check", "--reporter=unix" },
			stdin = false,
			stream = "stdout",
			ignore_exitcode = true, -- Biome returns non-zero when it finds issues
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", { source = "biome" }),
		}

		lint.linters_by_ft = {
			-- JS / TS → Biome
			javascript = { "biome" },
			typescript = { "biome" },
			javascriptreact = { "biome" }, -- .jsx
			typescriptreact = { "biome" }, -- .tsx

			-- Web / markup
			html = { "htmlhint" },
			json = { "biome" }, -- заменил jsonlint → biome; верни jsonlint, если нужно
			jsonc = { "biome" }, -- полезно для tsconfig и т.п.
			yaml = { "yamllint" },
			markdown = { "markdownlint" },

			-- Shell
			sh = { "shellcheck" },
			bash = { "shellcheck" },

			-- Go
			-- go = { "golangci_lint" },

			-- Java
			java = { "checkstyle" }, -- или { "pmd" }

			-- Docker
			dockerfile = { "hadolint" },

			-- EditorConfig
			editorconfig = { "editorconfig-checker" },

			-- Python
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>L", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
