return {
	"nvim-treesitter/playground",
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 1000,
		build = ":TSUpdate",
		config = function()
			vim.opt.smartindent = false
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				sync_install = false,
				ensure_installed = {
					"markdown",
					"html",
					"javascript",
					"typescript",
					"tsx",
					"query",
					"dart",
					"java",
					"c",
					"prisma",
					"bash",
					"go",
					"lua",
					"kdl",
					"vim",
					"terraform",
					"dockerfile",
					"yaml",
					"python",
				},
				highlight = {
					enable = true,
					disable = { "csv" }, -- list of language that will be disabled
				},
				indent = {
					enable = true,
					disable = function(lang, bufnr)
						local disallowed_filetypes = { "yaml", "dart" }
						return vim.tbl_contains(disallowed_filetypes, lang)
					end,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection    = "<c-j>",
						node_incremental  = "<c-j>",
						node_decremental  = "<c-k>",
						scope_incremental = "<c-l>",
					},
				}
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			local tscontext = require('treesitter-context')
			tscontext.setup {
				enable = true,
				max_lines = 0,        -- How many lines the window should span. Values <= 0 mean no limit
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
				trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = 'cursor',      -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			}
			vim.keymap.set("n", "[c", function()
				tscontext.go_to_context()
			end, { silent = true })
		end
	},
}
