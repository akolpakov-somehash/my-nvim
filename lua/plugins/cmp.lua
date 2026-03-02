return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",

			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",

			-- (опційно) автопари інтеграція
			"windwp/nvim-autopairs",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Завантажити готові snippets (VSCode-style)
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Якщо юзаєш nvim-autopairs
			local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			if cmp_autopairs_ok then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				if col == 0 then
					return false
				end
				local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
				return text:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false, -- true = підтверджує перший елемент автоматично
					}),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),

				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
							cmdline = "[Cmd]",
						}
						item.menu = menu_icon[entry.source.name] or ("[" .. entry.source.name .. "]")
						return item
					end,
				},

				experimental = {
					ghost_text = false, -- можеш увімкнути true, якщо подобається inline preview
				},
			})

			-- completion у пошуку "/" та "?"
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- completion у ":" командному рядку
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
