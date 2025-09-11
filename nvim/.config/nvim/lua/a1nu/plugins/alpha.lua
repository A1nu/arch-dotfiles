return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		_G.A1_restore_cwd = function()
			local ok = pcall(function()
				require("persistence").load({ last = false }) -- restore session for current dir
			end)
			if not ok then
				vim.notify("No session found for current directory", vim.log.levels.INFO)
			end
		end

		_G.A1_restore_last = function()
			local ok = pcall(function()
				require("persistence").load({ last = true }) -- restore most recent session (any dir)
			end)
			if not ok then
				vim.notify("No last session found", vim.log.levels.INFO)
			end
		end
		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC cw", "  > Open Yazi (cwd)", "<cmd>Yazi cwd<CR>"),
			dashboard.button("SPC cf", "  > Open Yazi (at current file)", "<cmd>Yazi<CR>"),
			dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session (cwd)", "<cmd>lua A1_restore_cwd()<CR>"),
			dashboard.button("SPC wl", "󰁮  > Restore Last Session", "<cmd>lua A1_restore_last()<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
