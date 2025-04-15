return {
	{
		"kevinhwang91/nvim-hlslens",
		lazy = false,
		enabled = true,
		keys = {
			{ "*",  "*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
			{ "#",  "#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
			{ "g*", "g*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
			{ "g#", "g#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		},
		config = function()
			require("scrollbar.handlers.search").setup()
		end
	},
	{
		"pechorin/any-jump.vim",
		config = function()
			vim.g.any_jump_disable_default_keybindings = true
			vim.g.any_jump_window_width_ratio = 0.9
			vim.g.any_jump_window_height_ratio = 0.9
		end
	},
	{
		"MagicDuck/grug-far.nvim",
		keys = {
			{
				"<leader>F",
				mode = "n",
				function()
					vim.cmd(":GrugFar")
				end,
				desc = "Project find and replace"
			},
			{
				"<leader>f", -- 使用小写f作为当前文件操作
				mode = "n",
				function()
					vim.cmd(":GrugFar -g %") -- % 表示当前文件
				end,
				desc = "Current file find and replace"
			},
			{
				"<leader>fw", -- 可视模式下在选中文本内搜索
				mode = "v",
				function()
					vim.cmd(":GrugFarWithin")
				end,
				desc = "Find and replace within selection"
			}
		},
	}
}
