return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				opts.desc = "Show documentation"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		local icons = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		if vim.fn.has("nvim-0.10") == 1 or vim.fn.has("nvim-0.11") == 1 then
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.Error,
						[vim.diagnostic.severity.WARN] = icons.Warn,
						[vim.diagnostic.severity.HINT] = icons.Hint,
						[vim.diagnostic.severity.INFO] = icons.Info,
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
						[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
						[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					},
				},
			})
		else
			for type, icon in pairs(icons) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end

		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument = capabilities.textDocument or {}
		capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

		local function disable_formatting(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		local function on_attach_disable_fmt(client, _)
			disable_formatting(client)
		end

		local servers = {
			ts_ls = {
				capabilities = capabilities,
				root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
				single_file_support = false,
				on_attach = on_attach_disable_fmt,
			},
			html = { capabilities = capabilities, on_attach = on_attach_disable_fmt },
			cssls = {
				capabilities = capabilities,
				filetypes = { "css", "scss", "less" },
				settings = { css = { validate = true }, scss = { validate = true }, less = { validate = true } },
				on_attach = on_attach_disable_fmt,
			},
			emmet_language_server = {
				capabilities = capabilities,
				filetypes = { "html", "css", "sass", "scss", "less", "javascriptreact", "typescriptreact", "svelte" },
			},
			-- jsonls = {
			-- 	capabilities = capabilities,
			-- 	settings = { json = { validate = { enable = true } } },
			-- 	on_attach = on_attach_disable_fmt,
			-- },
			yamlls = {
				capabilities = capabilities,
				settings = { yaml = { keyOrdering = false } },
				on_attach = on_attach_disable_fmt,
			},
			lemminx = { capabilities = capabilities },
			marksman = {
				capabilities = capabilities,
				filetypes = { "markdown", "markdown.mdx" },
				on_attach = on_attach_disable_fmt,
			},
			lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						completion = { callSnippet = "Replace" },
					},
				},
				on_attach = on_attach_disable_fmt,
			},
			bashls = { capabilities = capabilities, filetypes = { "sh", "bash" } },
			gopls = {
				capabilities = capabilities,
				settings = { gopls = { gofumpt = true, staticcheck = true, analyses = { unusedparams = true } } },
				on_attach = on_attach_disable_fmt,
			},
			clangd = {
				capabilities = capabilities,
				cmd = { "clangd", "--background-index", "--clang-tidy" },
				on_attach = on_attach_disable_fmt,
			},
			vimls = { capabilities = capabilities },
			dockerls = { capabilities = capabilities },
			ruff = {
				capabilities = capabilities,
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
					disable_formatting(client)
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
