require("config.lazy")
vim.opt.number = true -- show absolute line number on current line
vim.opt.relativenumber = true -- show relative numbers on other lines
vim.cmd.colorscheme("tokyonight")

vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focus = false,
			scope = "cursor",
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		})
	end,
})
--- Keys
vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>")
local builtin = require("telescope.builtin")
local telescope_ignore = { "var/", "dev/", "integration-tests/", "generated/" }
vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files({ no_ignore = true, file_ignore_patterns = telescope_ignore })
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", function()
	builtin.live_grep({
		additional_args = { "--no-ignore" },
		file_ignore_patterns = telescope_ignore,
	})
end, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })

-- TokyoNight-matching diagnostics UI
local function setup_diagnostics_tokyonight()
	-- Behavior / layout
	vim.diagnostic.config({
		underline = true,
		severity_sort = true,
		update_in_insert = false,

		-- keep inline text subtle (turn false if you want cleaner buffers)
		virtual_text = false,
		signs = true,

		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
			suffix = "",
			scope = "cursor",
			close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertEnter", "FocusLost" },
		},
	})

	-- TokyoNight-ish palette (night)
	local c = {
		bg_float = "#1a1b26", -- base bg
		bg_alt = "#16161e", -- slightly darker
		border = "#3b4261", -- subtle border
		fg = "#c0caf5", -- default fg
		err = "#f7768e",
		warn = "#e0af68",
		info = "#7aa2f7",
		hint = "#73daca",
	}

	-- Float container
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.fg, bg = c.bg_alt })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = c.border, bg = c.bg_alt })
	vim.api.nvim_set_hl(0, "FloatTitle", { fg = c.info, bg = c.bg_alt, bold = true })

	-- Diagnostic text inside float
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = c.err, bg = c.bg_alt })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = c.warn, bg = c.bg_alt })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = c.info, bg = c.bg_alt })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = c.hint, bg = c.bg_alt })

	-- Optional: make virtual text feel more integrated with TokyoNight
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = c.err, bg = "#2a1f28" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = c.warn, bg = "#2b261d" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = c.info, bg = "#1f2335" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = c.hint, bg = "#1d2b2a" })

	-- Underlines (optional, slightly cleaner than defaults on some themes)
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.err })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })
end

-- Run once now
setup_diagnostics_tokyonight()

-- Go DAP configuration
local ok_dap, dap = pcall(require, "dap")
if ok_dap then
	-- базове керування
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue/start" })
	vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP step over" })
	vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP step out" })
	vim.keymap.set("n", "<leader>dK", dap.run_to_cursor, { desc = "DAP run to cursor" })

	-- брейкпоінти
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
	vim.keymap.set("n", "<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "DAP conditional breakpoint" })
	vim.keymap.set("n", "<leader>dlp", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, { desc = "DAP log point" })

	-- UI / REPL
	vim.keymap.set("n", "<leader>du", function()
		require("dapui").toggle()
	end, { desc = "DAP UI toggle" })
	vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
	vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "DAP terminate" })
	vim.keymap.set("n", "<leader>dx", dap.disconnect, { desc = "DAP disconnect" })

	-- корисне
	vim.keymap.set({ "n", "v" }, "<leader>dh", function()
		require("dap.ui.widgets").hover()
	end, { desc = "DAP hover (inspect)" })
	vim.keymap.set("n", "<leader>d?", function()
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.scopes)
	end, { desc = "DAP scopes" })
end
