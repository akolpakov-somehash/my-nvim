return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp", -- optional, used for NES mode
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<C-l>",
						accept_word = "<C-j>",
						accept_line = "<C-k>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = {
					enabled = false,
				},
				nes = {
					enabled = false,
				},
			})
		end,
	},
}
