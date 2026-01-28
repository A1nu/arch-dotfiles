return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local util = require("lspconfig.util") -- root helpers
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		local telescope = require("telescope.builtin")

		-- Keymaps on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				opts.desc = "Show LSP references"
				keymap.set("n", "gr", telescope.lsp_references, opts)
				vim.keymap.set("n", "gR", function()
					require("telescope.builtin").lsp_references({
						include_declaration = false,
						fname_width = 0,
						show_line = false,
						trim_text = true,
					})
				end, { desc = "Usages (filtered)" })
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", telescope.lsp_definitions, opts)
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", telescope.lsp_implementations, opts)
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", telescope.lsp_type_definitions, opts)
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, opts)
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, opts)
				opts.desc = "Show documentation"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Diagnostics signs/icons
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

		-- Capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument = capabilities.textDocument or {}
		capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

		-- Helpers to disable formatting from server side
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
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
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
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						analyses = { unusedparams = true, unreachable = true },
						completeUnimported = true,
					},
				},
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

		-- Unified setup that supports both new and old API
		local has_new = vim.fn.has("nvim-0.11") == 1 and vim.lsp and vim.lsp.config

		if has_new then
			-- New API: register configs and auto-enable per filetype
			for name, opts in pairs(servers) do
				if opts ~= false then
					vim.lsp.config(name, opts) -- register config
					-- Auto-enable the server on matching filetypes for new buffers
					local fts = opts.filetypes
					if fts and #fts > 0 then
						vim.api.nvim_create_autocmd("FileType", {
							pattern = fts,
							callback = function(ev)
								-- Enable this server for the current buffer
								-- If your Neovim has vim.lsp.enable(name, { bufnr = ... }), use that:
								if pcall(vim.lsp.enable, name, { bufnr = ev.buf }) then
									return
								end
								-- Fallback to enabling all matching servers for the buffer
								vim.lsp.enable({ bufnr = ev.buf })
							end,
							desc = ("Enable LSP: %s"):format(name),
						})
					else
						-- If server doesn't declare filetypes, just enable on buffer read/new
						vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
							callback = function(ev)
								vim.lsp.enable(name, { bufnr = ev.buf })
							end,
							desc = ("Enable LSP (no ft): %s"):format(name),
						})
					end
				end
			end
		else
			-- Old API: lspconfig[server].setup
			local lspconfig = require("lspconfig")
			for name, opts in pairs(servers) do
				if opts ~= false then
					lspconfig[name].setup(opts)
				end
			end
		end
	end,
}
