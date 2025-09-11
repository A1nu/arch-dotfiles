-- lua/a1nu/plugins/persistence.lua
return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- load early so :q on a dirty session works
	opts = {
		-- what to save (good sane defaults)
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
		-- don't save these filetypes/windows
		pre_save = function()
			-- close special sidebars to avoid weird sessions
			pcall(function()
				require("nvim-tree.api").tree.close()
			end)
		end,
	},
	config = function(_, opts)
		require("persistence").setup(opts)

		-- Session-like keymaps (mirror your previous ones)
		local km = vim.keymap
		km.set("n", "<leader>wr", function()
			require("persistence").load()
		end, { desc = "Restore session for CWD" })
		km.set("n", "<leader>wl", function()
			require("persistence").load({ last = true })
		end, { desc = "Restore last session" })
		km.set("n", "<leader>ws", function()
			require("persistence").save()
		end, { desc = "Save session" })
		km.set("n", "<leader>wd", function()
			require("persistence").stop()
		end, { desc = "Do not save this session" })
	end,
}
