return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.configurations.go = dap.configurations.go or {}

			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DiagnosticError", -- делает точку красной
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "●",
				texthl = "DiagnosticWarn",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "◆",
				texthl = "DiagnosticInfo",
			})

			vim.fn.sign_define("DapStopped", {
				text = "➤",
				texthl = "DiagnosticInfo",
				linehl = "CursorLine",
			})
			table.insert(dap.configurations.go, {
				type = "go",
				name = "Debug cmd/simulate",
				request = "launch",
				program = "${workspaceFolder}/cmd/simulate",
				args = {
					"-it",
					"100000",
					"-rtp",
					"9500",
				},
			})

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "DAP start debug" })
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "DAP step over" })
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "DAP step into" })
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, { desc = "DAP step out" })
			vim.keymap.set("n", "<leader>b", function()
				dap.toggle_breakpoint()
			end, { desc = "DAP Add breakpoint" })
			vim.keymap.set({ "n", "v" }, "<leader>de", function()
				require("dapui").eval()
			end, { desc = "DAP eval expression" })
			vim.keymap.set("n", "<leader>dq", function()
				require("dap").terminate()
			end, { desc = "DAP Terminate" })
		end,
	},

	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
		end,
	},
}
