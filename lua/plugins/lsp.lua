return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Apply cmp capabilities to every LSP config.
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Better defaults for Neovim Lua development.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
					},
				},
			})

			local group = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = group,
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to definition",
					}))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to declaration",
					}))
				end,
			})
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls" },
		},
		dependencies = {
			{ "mason-org/mason.nvim" },
			"neovim/nvim-lspconfig",
		},
	},
}
