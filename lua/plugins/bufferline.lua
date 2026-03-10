return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{
				"<leader>bd",
				function()
					require("bufdelete").bufdelete(0, false)
				end,
				desc = "Close buffer",
			},
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
			{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers left" },
			{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers right" },
			{ "<leader>bm", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
			{ "<leader>bM", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
			{ "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
			{ "<leader>bD", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
		},
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					always_show_bufferline = true,
					auto_toggle_bufferline = true,
					close_command = function(bufnr)
						require("bufdelete").bufdelete(bufnr, false)
					end,
					right_mouse_command = function(bufnr)
						require("bufdelete").bufdelete(bufnr, false)
					end,
					show_close_icon = false,
					show_buffer_close_icons = true,
				},
			})
		end,
	},
	{
		"famiu/bufdelete.nvim",
		cmd = { "Bdelete", "Bwipeout" },
	},
}
