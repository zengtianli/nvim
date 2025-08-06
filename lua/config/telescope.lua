-- ==========================================
-- 统一Telescope配置
-- ==========================================

local M = {}
local m = { noremap = true, nowait = true }

M = {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local builtin = require('telescope.builtin')
      
      -- 基础键绑定
      vim.keymap.set('n', '<c-p>', builtin.find_files, m)
      vim.keymap.set('n', '<leader>rs', builtin.resume, m)
      vim.keymap.set('n', '<c-w>', builtin.buffers, m)
      vim.keymap.set('n', '<c-h>', builtin.oldfiles, m)
      vim.keymap.set('n', 'z=', builtin.spell_suggest, m)
      vim.keymap.set('n', '<leader>d', function()
        builtin.diagnostics({ sort_by = "severity" })
      end, m)
      vim.keymap.set('n', '<leader>gi', builtin.git_status, m)
      vim.keymap.set("n", ":", builtin.commands, m)

      -- 诊断配置
      vim.lsp.protocol.DiagnosticSeverity = {
        "Error", "Warning", "Information", "Hint",
        Error = 1, Hint = 4, Information = 3, Warning = 2
      }
      vim.diagnostic.severity = {
        "ERROR", "WARN", "INFO", "HINT",
        E = 1, ERROR = 1, HINT = 4, I = 3, INFO = 3, N = 4, W = 2, WARN = 2
      }

      local trouble = require("trouble.providers.telescope")
      local ts = require('telescope')
      local actions = require('telescope.actions')
      M.ts = ts

      -- Telescope主配置
      ts.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", "build", "dist", "%.pub%-cache" },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--fixed-strings", "--smart-case", "--trim"
          },
          layout_config = { width = 0.9, height = 0.9 },
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<esc>"] = "close",
              ["<C-j>"] = require('telescope.actions').cycle_history_next,
              ["<C-k>"] = require('telescope.actions').cycle_history_prev,
            }
          },
          color_devicons = true,
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer }
            }
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        }
      })

      -- 加载扩展
      ts.load_extension('fzf')
    end
  },

}

return M 