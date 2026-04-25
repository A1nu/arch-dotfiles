return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>s", group = "Split" },
      { "<leader>t", group = "Tab" },
      { "<leader>f", group = "Find" },
      { "<leader>x", group = "Trouble" },
      { "<leader>d", group = "Debug" },
      { "<leader>a", group = "AI (Claude)" },
      { "<leader>w", group = "Session" },
      { "<leader>c", group = "Code/Yazi" },
      { "<leader>l", group = "Lazygit/LSP" },
      { "<leader>r", group = "Rename/Restart" },
      { "<leader>m", group = "Format" },
    },
  },
}
