return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		hint_enable = false, -- disable inline virtual text if you only want the bubble
		floating_window = true, -- show popup bubble
		floating_window_above_cur_line = true,
		handler_opts = {
			border = "rounded",
		},
	},
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
