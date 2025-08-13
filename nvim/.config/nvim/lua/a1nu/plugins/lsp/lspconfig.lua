return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		local util = require("lspconfig.util")
		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local icons = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

		if vim.fn.has("nvim-0.10") == 1 or vim.fn.has("nvim-0.11") == 1 then
			-- New API: configure signs via vim.diagnostic.config
			vim.diagnostic.config({
				signs = {
					-- per-severity text
					text = {
						[vim.diagnostic.severity.ERROR] = icons.Error,
						[vim.diagnostic.severity.WARN] = icons.Warn,
						[vim.diagnostic.severity.HINT] = icons.Hint,
						[vim.diagnostic.severity.INFO] = icons.Info,
					},
					-- optional: highlight number column too
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
						[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
						[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					},
				},
			})
		else
			-- Fallback for older Neovim
			for type, icon in pairs(icons) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end

		-- local capabilities = cmp_nvim_lsp.default_capabilities()

		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument = capabilities.textDocument or {}
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local servers = {
			-- JS / TS
			ts_ls = {
				capabilities = capabilities,
				root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
				single_file_support = false,
			},
			eslint = {
				capabilities = capabilities,
				root_dir = util.root_pattern(
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					"package.json",
					".git"
				),
			},

			-- Web stack
			html = { capabilities = capabilities },
			cssls = {
				capabilities = capabilities,
				filetypes = { "css", "scss", "less" },
				settings = {
					css = { validate = true },
					scss = { validate = true },
					less = { validate = true },
				},
			},
			emmet_language_server = {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"sass",
					"scss",
					"less",
					"javascriptreact",
					"typescriptreact",
					"svelte",
				},
			},
			tailwindcss = {
				capabilities = capabilities,
				filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "svelte" },
				root_dir = util.root_pattern(
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.ts",
					"package.json",
					".git"
				),
			},

			-- Data / markup
			jsonls = {
				capabilities = capabilities,
				settings = { json = { validate = { enable = true } } },
			},
			yamlls = {
				capabilities = capabilities,
				settings = { yaml = { keyOrdering = false } },
			},
			lemminx = { capabilities = capabilities },
			marksman = { capabilities = capabilities, filetypes = { "markdown", "markdown.mdx" } },

			-- General languages
			lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						completion = { callSnippet = "Replace" },
					},
				},
			},
			bashls = { capabilities = capabilities, filetypes = { "sh", "bash" } },
			gopls = {
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						analyses = { unusedparams = true },
					},
				},
			},
			-- jdtls: recommended to start per-project via nvim-jdtls; skip global setup:
			-- jdtls = false,

			clangd = { capabilities = capabilities, cmd = { "clangd", "--background-index", "--clang-tidy" } },
			vimls = { capabilities = capabilities },
			dockerls = { capabilities = capabilities },

			ruff = {
				capabilities = capabilities,
				on_attach = function(client, _)
					-- Avoid duplicate hovers if using Pyright/BasedPyright
					client.server_capabilities.hoverProvider = false
				end,
			},

			basedpyright = {
				capabilities = capabilities,
				root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
			},
		}

		for server, opts in pairs(servers) do
			if opts ~= false then
				lspconfig[server].setup(opts)
			end
		end
	end,
}
