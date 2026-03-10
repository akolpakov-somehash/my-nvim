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

			vim.lsp.config("gopls", {})

			vim.lsp.enable({ "lua_ls", "gopls" })

			local group = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = group,
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					local ok_telescope, builtin = pcall(require, "telescope.builtin")

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to definition",
					}))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to declaration",
					}))
					vim.keymap.set("n", "gi", function()
						if ok_telescope then
							builtin.lsp_implementations()
							return
						end
						vim.lsp.buf.implementation()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to implementation",
					}))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
						desc = "LSP: Rename symbol",
					}))
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
						desc = "LSP: Code action",
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
			ensure_installed = { "lua_ls", "gopls" },
		},
		dependencies = {
			{ "mason-org/mason.nvim" },
			"neovim/nvim-lspconfig",
		},
	},
}
