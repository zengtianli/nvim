return {
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinNew" },
	},
	{
		"nyngwang/NeoZoom.lua",
		config = function()
			vim.keymap.set('n', '<leader>f', ':NeoZoomToggle<CR>', { silent = true, nowait = true })
			require('neo-zoom').setup {
				popup = { enabled = true }, -- this is the default.
				exclude_buftypes = { 'terminal' },
				-- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
				winopts = {
					offset = {
						-- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
						-- top = 0,
						-- left = 0.17,
						width = 1.0,
						height = 1.0,
					},
					-- NOTE: check :help nvim_open_win() for possible border values.
					border = 'thicc', -- this is a preset, try it :)
				},
				presets = {
					{
						filetypes = { 'markdown' },
						callbacks = {
							function() vim.wo.wrap = true end,
						},
					},
				},
			}
		end
	}
}
