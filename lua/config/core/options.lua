-- ==========================================
-- Neovim 核心选项配置
-- ==========================================

-- Python provider 配置
vim.g.python3_host_prog = vim.fn.exepath('python3') or '/Users/tianli/miniforge3/bin/python3'

-- 基础设置
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.sidescroll = 5
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣' }

-- 搜索设置
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 缩进设置
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- 文件处理
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.local/share/nvim/undo')

-- UI 设置
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 性能设置
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true

-- 折叠设置
vim.opt.foldmethod = 'manual'
vim.opt.foldlevel = 99

-- 其他设置
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } 