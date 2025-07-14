# Neovim 配置完全指南

#配置 #编辑器 #开发 #现代化

> ⚙️ **Neovim配置** 是现代化 [[Neovim] aaaaaa的核心，通过合理配置可以打造出强大的开发环境。

## 🔄 从 Vim 迁移

### 兼容性说明
Neovim 完全兼容 Vim 配置，你可以：
- 继续使用 `.vimrc`（Neovim 会自动加载）
- 使用 `init.vim`（推荐，更清晰的配置分离）
- 使用 `init.lua`（最推荐，完整利用 Neovim 现代特性）

### 配置文件位置
```bash
# Vim 配置文件
~/.vimrc                    # Unix-like 系统
%USERPROFILE%\_vimrc       # Windows

# Neovim 配置文件
~/.config/nvim/init.vim    # 传统 Vim 语法
~/.config/nvim/init.lua    # 现代 Lua 配置（推荐）
```

## 🌟 配置结构

### 基础目录结构
```
~/.config/nvim/
├── init.lua                 # 主配置文件
├── lua/
│   ├── core/                # 核心配置
│   │   ├── options.lua      # 基础选项
│   │   ├── keymaps.lua      # 键位映射
│   │   └── autocmds.lua     # 自动命令
│   ├── plugins/             # 插件配置
│   │   ├── init.lua         # 插件管理器
│   │   ├── lsp.lua          # LSP配置
│   │   ├── treesitter.lua   # 语法高亮
│   │   ├── telescope.lua    # 模糊搜索
│   │   └── cmp.lua          # 自动完成
│   └── utils/               # 工具函数
│       └── helpers.lua      # 辅助函数
```

### 主配置文件
```lua
-- ~/.config/nvim/init.lua

-- 设置 Leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 加载核心配置
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- 加载插件
require("plugins")

-- 加载工具函数
require("utils.helpers")
```

## ⚙️ 核心配置

### 基础选项配置
```lua
-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- Vim 兼容性设置
vim.g.loaded_netrw = 1        -- 禁用 netrw
vim.g.loaded_netrwPlugin = 1  -- 禁用 netrw 插件
vim.g.mapleader = " "         -- 设置 Leader 键
vim.g.maplocalleader = "\\"   -- 设置 Local Leader 键

-- 行号和相对行号
opt.number = true
opt.relativenumber = true

-- 缩进设置
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- 搜索设置
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 外观设置
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- 文件和备份
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.swapfile = false

-- 分割窗口
opt.splitbelow = true
opt.splitright = true

-- 其他设置
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.updatetime = 300
opt.timeoutlen = 500
opt.completeopt = { "menuone", "noselect" }
```

### 键位映射配置
```lua
-- ~/.config/nvim/lua/core/keymaps.lua

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 基础编辑
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>x", ":x<CR>", opts)

-- 窗口管理
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- 分割窗口
keymap("n", "<leader>sv", ":vsplit<CR>", opts)
keymap("n", "<leader>sh", ":split<CR>", opts)
keymap("n", "<leader>se", "<C-w>=", opts)
keymap("n", "<leader>sx", ":close<CR>", opts)

-- 标签页管理
keymap("n", "<leader>to", ":tabnew<CR>", opts)
keymap("n", "<leader>tx", ":tabclose<CR>", opts)
keymap("n", "<leader>tn", ":tabn<CR>", opts)
keymap("n", "<leader>tp", ":tabp<CR>", opts)

-- 缓冲区导航
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- 文本编辑
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 搜索和替换
keymap("n", "<leader>nh", ":nohl<CR>", opts)
keymap("n", "<leader>rs", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", opts)

-- 快速跳转
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
```

## 🔌 插件管理

### Lazy.nvim 配置
```lua
-- ~/.config/nvim/lua/plugins/init.lua

-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 插件规范
require("lazy").setup({
  -- 颜色主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  -- 文件浏览器
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- 模糊搜索
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- LSP 配置
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("plugins.lsp")
    end,
  },

  -- 自动完成
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.cmp")
    end,
  },

  -- 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins.treesitter")
    end,
  },

  -- Git 集成
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- 注释插件
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- 括号自动配对
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- 缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
})
```

## 🔍 LSP 配置

### Language Server 设置
```lua
-- ~/.config/nvim/lua/plugins/lsp.lua

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- Mason 设置
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Mason LSP 配置
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "tsserver",
    "rust_analyzer",
    "gopls",
    "clangd",
    "java_language_server",
  },
  automatic_installation = true,
})

-- LSP 能力配置
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 通用 LSP 设置
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- LSP 快捷键
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

-- 自动配置 LSP 服务器
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,

  -- Lua 特殊配置
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
  end,
})
```

## 🔭 Telescope 配置

### 模糊搜索设置
```lua
-- ~/.config/nvim/lua/plugins/telescope.lua

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "❯ ",
    path_display = { "truncate" },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "dist/",
      "build/",
      "*.pyc",
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "ivy",
      previewer = false,
    },
    live_grep = {
      theme = "ivy",
    },
    buffers = {
      theme = "ivy",
      previewer = false,
    },
  },
})

-- Telescope 快捷键
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fc", ":Telescope commands<CR>", opts)
keymap("n", "<leader>fk", ":Telescope keymaps<CR>", opts)
```

## 🎨 主题和外观

### 主题配置
```lua
-- ~/.config/nvim/lua/plugins/colorscheme.lua

-- Catppuccin 主题配置
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    treesitter = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
  },
})

-- 设置颜色方案
vim.cmd.colorscheme "catppuccin"
```

## 🔗 工具集成

### [[Git]] 集成
```lua
-- Git 相关配置
require("gitsigns").setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
  },
})
```

### [[Tmux]] 集成
```lua
-- Tmux 导航集成
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
```

### [[FZF]] 集成
```lua
-- FZF 与 Telescope 结合使用
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
  })
end)

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden" }
    end
  })
end)
```

## 🚀 高级配置

### 自动命令
```lua
-- ~/.config/nvim/lua/core/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 高亮选中文本
augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- 自动保存和恢复折叠
augroup("AutoSaveLoad", {})
autocmd({ "BufWinLeave" }, {
  group = "AutoSaveLoad",
  pattern = "*.*",
  desc = "save view (folds), when closing file",
  command = "mkview",
})
autocmd({ "BufWinEnter" }, {
  group = "AutoSaveLoad",
  pattern = "*.*",
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})

-- 去除行尾空格
augroup("TrimWhitespace", {})
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- 自动调整窗口大小
augroup("AutoResize", {})
autocmd("VimResized", {
  group = "AutoResize",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
```

### 性能优化
```lua
-- ~/.config/nvim/lua/core/performance.lua

-- 减少重绘
vim.opt.lazyredraw = true

-- 优化搜索
vim.opt.regexpengine = 1

-- 限制语法高亮
vim.opt.synmaxcol = 240

-- 禁用不需要的插件
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
```

## 📚 相关资源

### 学习指南
- [[Neovim]] - Neovim 基础介绍
- [[Vim完整指南]] - Vim 基础知识
- [[开发环境配置指南]] - 开发环境设置

### 相关配置
- [[Vim配置]] - 传统 Vim 配置
- [[FZF配置]] - FZF 搜索工具配置
- [[Tmux配置]] - 终端复用器配置

### 故障排除
- [[系统管理与故障排除指南]] - 配置问题解决

---

*⚙️ **提示**：Neovim 配置是一个渐进过程，建议从基础配置开始，逐步添加插件和功能，避免一次性配置过多导致问题难以排查。* 

## 📝 从 Vim 迁移建议

### 循序渐进的迁移
1. **保持 Vim 配置**：先使用 `init.vim` 加载现有的 `.vimrc`
2. **逐步迁移到 Lua**：
   - 从简单的选项设置开始
   - 然后是键位映射
   - 最后是插件配置
3. **使用现代替代品**：
   - vim-plug → Lazy.nvim
   - NERDTree → nvim-tree
   - fzf.vim → Telescope
   - coc.nvim → 内置 LSP
   - vimscript 插件 → Lua 插件

### 配置转换示例
```lua
-- Vim 配置
" set number
" set relativenumber
" set tabstop=4

-- Neovim Lua 配置
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4

-- Vim 映射
" nnoremap <leader>w :w<CR>
" vnoremap < <gv

-- Neovim Lua 映射
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('v', '<', '<gv')
```

### 注意事项
- 使用 Lua 配置可以获得更好的性能
- 内置 LSP 比 coc.nvim 更轻量和集成
- Telescope 提供比 fzf.vim 更现代的体验
- 模块化配置更容易维护
- 保留一些有用的 Vim 兼容性设置

---

*🚀 **提示**：Neovim 不仅仅是 Vim 的升级版，它提供了更现代的编辑体验。充分利用其 Lua 生态系统和内置 LSP 可以打造出专业的 IDE 级开发环境。* 