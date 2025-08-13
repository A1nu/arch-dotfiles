-- lua/plugins/ufo.lua
return {
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		init = function()
			-- Recommended window options for UFO
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		opts = {
			-- Prefer Treesitter, fall back to indent if no parser
			provider_selector = function(_, _, _)
				return { "treesitter", "indent" }
			end,
			open_fold_hl_timeout = 0,
			preview = { win_config = { border = "rounded", winblend = 0 } },
		},
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "UFO: Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "UFO: Close all folds",
			},
			{
				"zK",
				function()
					local winid = require("ufo").peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end,
				desc = "UFO: Peek fold / LSP hover",
			},
		},
	},
}
