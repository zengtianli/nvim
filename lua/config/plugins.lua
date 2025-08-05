-- ==========================================
-- 统一插件配置
-- ==========================================

-- 初始化 lazy.nvim 插件管理器
local function setup_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- 配置 lazy 命令快捷键
  local lazy_cmd = require("lazy.view.config").commands
  local lazy_keys = {
    { cmd = "install", key = "i" }, { cmd = "update", key = "u" },
    { cmd = "sync", key = "s" }, { cmd = "clean", key = "cl" },
    { cmd = "check", key = "ch" }, { cmd = "log", key = "l" },
    { cmd = "restore", key = "rs" }, { cmd = "profile", key = "p" },
  }
  for _, v in ipairs(lazy_keys) do
    lazy_cmd[v.cmd].key = "<SPC>" .. v.key
    lazy_cmd[v.cmd].key_plugin = "<leader>" .. v.key
  end
  vim.keymap.set("n", "<leader>pl", ":Lazy<CR>", { noremap = true })
end

setup_lazy()

-- 插件配置列表
local plugins = {
  -- ==========================================
  -- 颜色主题
  -- ==========================================
  {
    "theniceboy/nvim-deus",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme deus]])
    end,
  },

  -- ==========================================
  -- UI 界面增强
  -- ==========================================
  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { statusline = {}, winbar = {} },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = { statusline = 1000, tabline = 1000, winbar = 1000 }
        },
        sections = {
          lualine_a = { 'filename' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'filesize', 'fileformat', 'filetype' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {}, lualine_b = {}, lualine_c = { 'filename' },
          lualine_x = { 'location' }, lualine_y = {}, lualine_z = {}
        },
        tabline = {}, winbar = {}, inactive_winbar = {}, extensions = {}
      }
    end
  },

  -- 标签栏
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = "tabs",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        indicator = { icon = '▎', style = "icon" },
        show_buffer_close_icons = false,
        show_close_icon = false,
        enforce_regular_tabs = true,
        show_duplicate_prefix = false,
        tab_size = 16,
        padding = 0,
        separator_style = "thick",
      }
    }
  },



  -- 滚动条
  {
    "petertriho/nvim-scrollbar",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    config = function()
      local group = vim.api.nvim_create_augroup("scrollbar_set_git_colors", {})
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          vim.cmd([[
hi! ScrollbarGitAdd guifg=#8CC85F
hi! ScrollbarGitAddHandle guifg=#A0CF5D
hi! ScrollbarGitChange guifg=#E6B450
hi! ScrollbarGitChangeHandle guifg=#F0C454
hi! ScrollbarGitDelete guifg=#F87070
hi! ScrollbarGitDeleteHandle guifg=#FF7B7B ]])
        end,
        group = group,
      })
      require("scrollbar.handlers.search").setup({})
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar").setup({
        show = true,
        handle = { text = " ", color = "#928374", hide_if_all_visible = true },
        marks = { Search = { color = "yellow" }, Misc = { color = "purple" } },
        handlers = { cursor = false, diagnostic = true, gitsigns = true, handle = true, search = true }
      })
    end,
  },

  -- 通知系统
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      vim.notify = function(msg, ...)
        if string.match(msg, "error drawing label for") then return end
        require("notify")(msg, ...)
      end
      notify.setup({
        on_open = function(win) vim.api.nvim_win_set_config(win, { border = "none" }) end,
        background_colour = "#202020", fps = 60, level = 2, minimum_width = 50,
        render = "compact", stages = "fade_in_slide_out", timeout = 3000, top_down = true
      })
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", ",;", function()
        require('telescope').extensions.notify.notify({
          layout_strategy = 'vertical', layout_config = { width = 0.9, height = 0.9 },
          wrap_results = true, previewer = false
        })
      end, opts)
      vim.keymap.set("n", "<LEADER>c;", notify.dismiss, opts)
    end
  },

  -- ==========================================
  -- 编辑增强
  -- ==========================================
  -- 注释增强
  {
    "tomtom/tcomment_vim",
    event = "BufRead",
    config = function()
      vim.g.tcomment_maps = true
      vim.g.tcomment_textobject_inlinecomment = ''
      vim.cmd([[
nmap <LEADER>cn g>c
vmap <LEADER>cn g>
nmap <LEADER>cu g<c
vmap <LEADER>cu g<
unmap ic
      ]])
    end
  },

  -- 包围编辑
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end
  },

  -- 多光标
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.cmd([[noremap <leader>sa <Plug>(VM-Select-All)]])
    end
  },

  -- 快速跳转
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "arstneiowfuydh",
      jump = { jumplist = true, pos = "start", history = false, register = false, nohlsearch = false, autojump = false, inclusive = nil },
      label = { uppercase = false, exclude = "", current = false, after = true, before = false, style = "inline", reuse = "all", distance = true, min_pattern_length = 0, rainbow = { enabled = true, shade = 8 } },
      modes = {
        search = { enabled = false },
        char = { enabled = false },
        treesitter = {
          labels = "arstneiowfuydh", jump = { pos = "range" }, search = { incremental = false },
          label = { before = true, after = true, style = "inline" },
          highlight = { backdrop = false, matches = false }
        },
        treesitter_search = {
          jump = { pos = "range" }, search = { multi_window = true, wrap = true, incremental = false },
          remote_op = { restore = true }, label = { before = true, after = true, style = "inline" }
        },
        remote = { remote_op = { restore = true, motion = true } }
      },
      prompt = {
        enabled = true, prefix = { { "⚡", "FlashPromptIcon" } },
        win_config = { relative = "editor", width = 1, height = 1, row = -1, col = 0, zindex = 1000 }
      }
    },
    keys = {
      { "tt", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "/", mode = { "o", "x" }, function() require("flash").jump() end, desc = "Flash Treesitter Search" }
    }
  },

  -- 编辑器增强
  {
    "RRethy/vim-illuminate",
    config = function()
      require('illuminate').configure({ providers = { 'regex' } })
      vim.cmd("hi IlluminatedWordText guibg=#393E4D gui=none")
    end
  },
  {
    "dkarter/bullets.vim",
    lazy = false,
    ft = { "markdown", "txt" },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true, RRGGBB = true, names = true, RRGGBBAA = false, AARRGGBB = true,
        rgb_fn = false, hsl_fn = false, css = false, css_fn = false,
        mode = "virtualtext", tailwind = true, sass = { enable = false }, virtualtext = "■"
      },
      buftypes = {}
    }
  },
  { 'theniceboy/antovim', lazy = false },
  { 'gcmt/wildfire.vim', lazy = false },

  -- 移动增强
  {
    "fedepujol/move.nvim",
    config = function()
      require('move').setup({
        line = { enable = true, indent = true },
        block = { enable = true, indent = true },
        word = { enable = false },
        char = { enable = false }
      })
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<c-j>', ':MoveLine(1)<CR>', opts)
      vim.keymap.set('n', '<c-k>', ':MoveLine(-1)<CR>', opts)
      vim.keymap.set('v', '<c-j>', ':MoveBlock(1)<CR>', opts)
      vim.keymap.set('v', '<c-k>', ':MoveBlock(-1)<CR>', opts)
    end
  },

  -- 替换增强
  {
    "gbprod/substitute.nvim",
    config = function()
      local substitute = require("substitute")
      substitute.setup({ highlight_substituted_text = { enabled = true, timer = 200 } })
      vim.keymap.set("n", "s", substitute.operator, { noremap = true })
      vim.keymap.set("n", "sh", function() substitute.operator({ motion = "e" }) end, { noremap = true })
      vim.keymap.set("x", "s", require('substitute.range').visual, { noremap = true })
      vim.keymap.set("n", "ss", substitute.line, { noremap = true })
      vim.keymap.set("n", "sI", substitute.eol, { noremap = true })
      vim.keymap.set("x", "s", substitute.visual, { noremap = true })
    end
  },

  -- 折叠增强
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function() require('ufo').setup() end
  },

  -- 自动配对
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup({}) end
  },

  -- 历史记录
  {
    "mbbill/undotree",
    config = function()
      vim.cmd([[
noremap <leader>l :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
endfunc]])
    end
  },

  -- 剪贴板增强
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { 'nvim-telescope/telescope.nvim', { 'kkharji/sqlite.lua', module = 'sqlite' } },
    config = function()
      vim.keymap.set("n", "<leader>y", ":Telescope neoclip<CR>", { noremap = true })
      require('neoclip').setup({
        history = 1000,
        enable_persistent_history = true,
        keys = {
          telescope = {
            i = {
              select = '<c-y>', paste = '<cr>', paste_behind = '<c-g>',
              replay = '<c-q>', delete = '<c-d>', edit = '<c-k>', custom = {}
            }
          }
        }
      })
    end
  },

  -- ==========================================
  -- 语言支持和开发工具
  -- ==========================================
  -- LSP 和补全 (使用独立的lsp.lua配置)
  require("config.lsp")[1],
  require("config.lsp")[2],

  -- 语法高亮
  {
    "nvim-treesitter/playground"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 1000,
    build = ":TSUpdate",
    config = function()
      -- 禁用内置的折叠，使用 ufo 插件代替
      vim.opt.foldmethod = "manual"
      vim.opt.foldexpr = ""
      vim.opt.smartindent = false

      require("nvim-treesitter.configs").setup({
        auto_install = false,  -- 禁用自动安装
        sync_install = false,
        ensure_installed = {
          "lua", "vim", "vimdoc",  -- 只保留最基础的几个
        },
        highlight = { 
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,  -- 禁用 treesitter 缩进
        },
        incremental_selection = {
          enable = false,  -- 禁用增量选择
        }
      })

      -- 设置更保守的高亮限制
      vim.g.ts_highlight_lua = false  -- 禁用 Lua 高亮优化
      vim.g.ts_highlight = false      -- 禁用所有高亮优化
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local tscontext = require('treesitter-context')
      tscontext.setup {
        enable = true, max_lines = 0, min_window_height = 0, line_numbers = true,
        multiline_threshold = 20, trim_scope = 'outer', mode = 'cursor',
        separator = nil, zindex = 20, on_attach = nil
      }
      vim.keymap.set("n", "[c", function() tscontext.go_to_context() end, { silent = true })
    end
  },

  -- 调试器
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "ravenxrz/DAPInstall.nvim",
        config = function()
          local dap_install = require("dap-install")
          dap_install.setup({ installation_path = vim.fn.stdpath("data") .. "/dapinstall/" })
        end
      },
      "theHamsta/nvim-dap-virtual-text",
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      local m = { noremap = true }
      vim.keymap.set("n", "<leader>'t", dap.toggle_breakpoint, m)
      vim.keymap.set("n", "<leader>'v", require('dap.ui.widgets').hover, m)
      vim.keymap.set("n", "<leader>'n", function()
        vim.cmd("write")
        local filetype = vim.bo.filetype
        if filetype == "cpp" or filetype == "c" then
          os.execute("gcc " .. vim.fn.expand("%") .. " -g -o " .. vim.fn.expand("%<"))
        end
        dap.continue()
      end, m)
      vim.keymap.set("n", "<leader>'s", dap.step_over, m)
      vim.keymap.set("n", "<leader>'q", dap.terminate, m)
      vim.keymap.set("n", "<leader>'u", dapui.toggle, m)

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#ffffff', bg = '#FE3C25' })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      dap.adapters.codelldb = {
        type = 'server', port = "${port}",
        executable = { command = vim.g.codelldb_path, args = { "--port", "${port}" } }
      }
      dap.configurations.cpp = {
        {
          name = "Launch file", type = "codelldb", request = "launch",
          program = function()
            local exe = vim.g.c_debug_program or vim.fn.expand("%:r")
            return vim.fn.getcwd() .. '/' .. exe
          end,
          cwd = '${workspaceFolder}', stopOnEntry = false
        }
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      local dap_install = require("dap-install")
      dap_install.config("codelldb", {})
    end
  },

  -- 语言特定插件
  {
    "instant-markdown/vim-instant-markdown",
    ft = { "markdown" },
    build = "yarn install",
    config = function() vim.g.instant_markdown_autostart = 0 end
  },
  -- Markdown 目录生成
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",
    cmd = { "Mtoc" },
    config = function()
      require('mtoc').setup({
        headings = {
          before_toc = false,  -- 不包含 TOC 前的标题
        },
        fences = {
          enabled = true,
          start_text = "mtoc-start",
          end_text = "mtoc-end"
        },
        auto_update = true,  -- 保存时自动更新
        toc_list = {
          markers = '*',
          cycle_markers = false,
        },
      })
      
      -- 设置快捷键
      vim.keymap.set("n", "<leader>mt", ":Mtoc<CR>", { noremap = true, silent = true, desc = "生成/更新 TOC" })
      vim.keymap.set("n", "<leader>mi", ":Mtoc insert<CR>", { noremap = true, silent = true, desc = "插入 TOC" })
      vim.keymap.set("n", "<leader>mu", ":Mtoc update<CR>", { noremap = true, silent = true, desc = "更新 TOC" })
      vim.keymap.set("n", "<leader>mr", ":Mtoc remove<CR>", { noremap = true, silent = true, desc = "删除 TOC" })
    end
  },
  -- Marp 幻灯片预览
  {
    "mpas/marp-nvim",
    ft = { "markdown" },
    config = function()
      require("marp").setup({
        port = 8080,  -- Marp 服务器端口
        wait_for_response_timeout = 10,  -- 等待服务器响应的超时时间
        wait_for_response_delay = 1,     -- 连接重试延迟
      })
    end
  },
  -- 表格模式
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "text", "rst", "org" },
    config = function()
      -- 表格模式配置
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_corner_corner = '|'
      vim.g.table_mode_header_fillchar = '='
      vim.g.table_mode_align_char = ':'
      vim.g.table_mode_delimiter = ' | '
      vim.g.table_mode_fillchar = '-'
    end
  },
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_quickfix_ignore_filters = { 'Font shape', "badness 10000", "Package hyperref Warning" }
    end
  },
  {
    'theniceboy/flutter-tools.nvim',
    ft = 'dart',
    dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim' }
  },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
    config = function()
      vim.g.dart_corelib_highlight = false
      vim.g.dart_format_on_save = false
    end
  },
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("go").setup({})
      local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function() require('go.format').goimport() end,
        group = format_sync_grp
      })
    end,
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()'
  },

  -- 版本控制
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '▎' }, change = { text = '░' }, delete = { text = '_' },
          topdelete = { text = '▔' }, changedelete = { text = '▒' }, untracked = { text = '┆' }
        }
      })
      vim.keymap.set("n", "<leader>g-", ":Gitsigns prev_hunk<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g=", ":Gitsigns next_hunk<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>l", ":Gitsigns preview_hunk<CR>", { noremap = true, silent = true })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    keys = { "<c-g>" },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 1.0
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_use_neovim_remote = true
      vim.keymap.set("n", "<c-g>", ":LazyGit<CR>", { noremap = true, silent = true })
    end
  },

  -- AI 助手
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_enabled = true
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap('n', '<leader>go', ':Copilot<CR>', { silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ge', ':Copilot enable<CR>', { silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gd', ':Copilot disable<CR>', { silent = true })
      vim.api.nvim_set_keymap('i', '<c-p>', '<Plug>(copilot-suggest)', { noremap = true })
      vim.api.nvim_set_keymap('i', '<c-l>', '<Plug>(copilot-next)', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('i', '<c-h>', '<Plug>(copilot-previous)', { noremap = true, silent = true })
      vim.cmd('imap <silent><script><expr> <C-C> copilot#Accept("")')
      vim.cmd([[let g:copilot_filetypes = { 'TelescopePrompt': v:false }]])
    end
  },

  -- ==========================================
  -- 导航和搜索
  -- ==========================================
  require("config.telescope")[1],
  require("config.telescope")[2],

  -- 快速搜索
  {
    "theniceboy/fzf-lua",
    keys = { "<c-f>" },
    config = function()
      local fzf = require('fzf-lua')
      local m = { noremap = true }
      vim.keymap.set('n', '<c-f>', function()
        fzf.grep({ search = "", fzf_opts = { ['--layout'] = 'default' } })
      end, m)
      vim.keymap.set('x', '<c-f>', function()
        fzf.grep_visual({ fzf_opts = { ['--layout'] = 'default' } })
      end, m)
      fzf.setup({
        global_resume = true, global_resume_query = true,
        winopts = {
          height = 1, width = 1, preview = { layout = 'vertical', scrollbar = 'float' },
          fullscreen = true, vertical = 'down:45%', horizontal = 'right:60%', hidden = 'nohidden'
        },
        keymap = {
          builtin = {
            ["<c-f>"] = "toggle-fullscreen", ["<c-r>"] = "toggle-preview-wrap",
            ["<c-p>"] = "toggle-preview", ["<c-y>"] = "preview-page-down",
            ["<c-l>"] = "preview-page-up", ["<S-left>"] = "preview-page-reset"
          },
          fzf = {
            ["esc"] = "abort", ["ctrl-h"] = "unix-line-discard", ["ctrl-k"] = "half-page-down",
            ["ctrl-b"] = "half-page-up", ["ctrl-n"] = "beginning-of-line", ["ctrl-a"] = "end-of-line",
            ["alt-a"] = "toggle-all", ["f3"] = "toggle-preview-wrap", ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down", ["shift-up"] = "preview-page-up",
            ["ctrl-e"] = "down", ["ctrl-u"] = "up"
          }
        },
        previewers = {
          head = { cmd = "head", args = nil },
          git_diff = { cmd_deleted = "git diff --color HEAD --", cmd_modified = "git diff --color HEAD", cmd_untracked = "git diff --color --no-index /dev/null" },
          man = { cmd = "man -c %s | col -bx" },
          builtin = { syntax = true, syntax_limit_l = 0, syntax_limit_b = 1024 * 1024, jump_to_line = true, title = false }
        },
        files = {
          prompt = 'Files❯ ', multiprocess = true, git_icons = true, file_icons = true, color_icons = true,
          find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
          rg_opts = "--color=never --files --hidden --follow -g '!.git'",
          fd_opts = "--color=never --type f --hidden --follow --exclude .git"
        },
        buffers = { prompt = 'Buffers❯ ', file_icons = true, color_icons = true, sort_lastused = true },
        grep = { rg_opts = "--color=always --line-number --column --smart-case --ignore-file=.fzfignore", previewer = "builtin", jump_to_line = true }
      })
    end
  },

  -- 高亮搜索
  {
    "kevinhwang91/nvim-hlslens",
    lazy = false,
    enabled = true,
    keys = {
      { "*", "*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "#", "#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "g*", "g*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "g#", "g#" .. [[<cmd>lua require("hlslens").start()<cr>]] }
    },
    config = function() require("scrollbar.handlers.search").setup() end
  },

  -- 跳转工具
  {
    "pechorin/any-jump.vim",
    config = function()
      vim.g.any_jump_disable_default_keybindings = true
      vim.g.any_jump_window_width_ratio = 0.9
      vim.g.any_jump_window_height_ratio = 0.9
    end
  },

  -- 查找替换
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>F", mode = "n", function() vim.cmd(":GrugFar") end, desc = "Project find and replace" },
      { "<leader>f", mode = "n", function() vim.cmd(":GrugFar -g %") end, desc = "Current file find and replace" },
      { "<leader>fw", mode = "v", function() vim.cmd(":GrugFarWithin") end, desc = "Find and replace within selection" }
    }
  },

  -- 项目管理
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { '__vim_project_root', '.git/' }
      vim.g.rooter_silent_chdir = true
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function() vim.cmd([[silent! source .vim.lua]]) end
      })
    end
  },

  -- 文件管理
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = { { "R", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" } },
    opts = {
      floating_window_scaling_factor = 1, yazi_floating_window_border = "none",
      open_for_directories = true, open_multiple_tabs = true,
      keymaps = {
        show_help = '<f1>', open_file_in_vertical_split = '<c-v>',
        open_file_in_horizontal_split = '<c-x>', open_file_in_tab = '<c-t>',
        grep_in_directory = '<c-f>', replace_in_directory = '<c-r>',
        cycle_open_buffers = '<tab>', copy_relative_path_to_selected_files = '<c-y>',
        send_to_quickfix_list = '<c-q>'
      }
    }
  },

  -- ==========================================
  -- 实用工具
  -- ==========================================
  -- 自动补全 (使用独立的autocomplete.lua配置)
  require("config.autocomplete"),

  -- CSV 支持
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = { 'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon' },
    cmd = { 'RainbowDelim', 'RainbowDelimSimple', 'RainbowDelimQuoted', 'RainbowMultiDelim' }
  },

  -- 命令行增强
  {
    'gelguy/wilder.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local wilder = require('wilder')
      wilder.setup { modes = { ':' }, next_key = '<Tab>', previous_key = '<S-Tab>' }
      wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_palette_theme({
          highlights = { border = 'Normal' },
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() },
          border = 'rounded', max_height = '75%', min_height = 0,
          prompt_position = 'top', reverse = 0
        })
      ))
      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline({ language = 'vim', fuzzy = 1 }),
          wilder.search_pipeline()
        )
      })
    end
  },

  -- 性能分析工具
  { "dstein64/vim-startuptime" },

  -- 其他辅助工具
  {
    "shellRaining/hlchunk.nvim",
    init = function()
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL" })
      require('hlchunk').setup({
        chunk = { enable = true, use_treesitter = true, style = { { fg = "#806d9c" } } },
        indent = { chars = { "│", "¦", "┆", "┊" }, use_treesitter = false },
        blank = { enable = false },
        line_num = { use_treesitter = true }
      })
    end
  }
}

-- 启动 lazy.nvim 并加载所有插件
require("lazy").setup(plugins, {})

-- 加载自定义插件
-- 垂直光标移动
require("plugin.vertical_cursor_movement")

-- 三元运算符交换工具
local swap_ternary = require("plugin.swap_ternary")
vim.keymap.set("n", "<leader>st", swap_ternary.swap_ternary, { noremap = true })

-- 编译运行工具
require("plugin.compile_run")
