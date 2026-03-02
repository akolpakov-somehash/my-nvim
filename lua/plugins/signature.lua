return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	keys = {
		{
			"<C-k>",
			function()
				require("lsp_signature").toggle_float_win()
			end,
			mode = "n",
			desc = "Toggle signature",
		},
	},
}
