return {
	"leoluz/nvim-dap-go",
	dependencies = { "mfussenegger/nvim-dap" },
	ft = "go",
	config = function()
		require("dap-go").setup({
			delve = {
				path = "dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
			},
		})

		-- хоткеи (опционально)
		vim.keymap.set("n", "<leader>dt", function()
			require("dap-go").debug_test()
		end, { desc = "Debug Go test" })

		vim.keymap.set("n", "<leader>dT", function()
			require("dap-go").debug_last_test()
		end, { desc = "Debug last Go test" })
	end,
}
