return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				php = { "php-cs-fixer" },
				go = { "goimports", "gofumpt" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				less = { "prettierd" },
				xml = { "xmlformatter" },
				sql = { "sql-formatter" },
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
