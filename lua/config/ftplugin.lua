-- ==========================================
-- 统一文件类型配置
-- ==========================================

local M = {}

function M.setup()
  -- ==========================================
  -- 通用设置
  -- ==========================================
  
  -- 基础语言的缩进设置（2空格）
  local basic_indent_langs = { 'c', 'java', 'graphml', 'racket', 'text' }
  for _, lang in ipairs(basic_indent_langs) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = lang,
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.smarttab = true
      end
    })
  end

  -- 4空格缩进的语言
  local wide_indent_langs = { 'cs', 'swift' }
  for _, lang in ipairs(wide_indent_langs) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = lang,
      callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.smarttab = true
      end
    })
  end

  -- ==========================================
  -- 特定语言配置
  -- ==========================================

  -- C# 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
      vim.keymap.set("n", "<LEADER>aw", ":CocAction<CR>", { buffer = true })
    end
  })

  -- Go 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.keymap.set("n", "<LEADER>tf", ":GoTestFunc<CR>", { buffer = true })
    end
  })

  -- Prisma 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "prisma",
    callback = function()
      vim.keymap.set("n", "<LEADER>'r", ":noa w<CR>:silent exec \"!npx prisma format\"<CR>:e<CR>", { buffer = true })
    end
  })

  -- Racket 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "racket",
    callback = function()
      vim.g.AutoPairs = {
        ['('] = ')', ['['] = ']', ['{'] = '}', ['"'] = '"',
        ["`"] = "`", ['```'] = '```', ['"""'] = '"""', ["'''"] = "'''"
      }
    end
  })

  -- Dart/Flutter 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dart",
    callback = function()
      -- Flutter相关键绑定
      vim.keymap.set('n', '<c-c>', function()
        require("telescope").extensions.flutter.commands()
      end, { buffer = true, noremap = true })
      
      vim.keymap.set('n', "<leader>'c", ":FlutterLogClear<CR>", { buffer = true, noremap = true })
      vim.keymap.set('n', "<leader>'r", ":FlutterRestart<CR>", { buffer = true, noremap = true })

      -- Flutter日志切换功能
      local toggle_log = function()
        local wins = vim.api.nvim_list_wins()
        for _, id in pairs(wins) do
          local bufnr = vim.api.nvim_win_get_buf(id)
          if vim.api.nvim_buf_get_name(bufnr):match '.*/([^/]+)$' == '__FLUTTER_DEV_LOG__' then
            return vim.api.nvim_win_close(id, true)
          end
        end
        pcall(function()
          vim.api.nvim_command 'sb + __FLUTTER_DEV_LOG__ | resize 15'
        end)
      end

      vim.keymap.set('n', "<leader>'l", toggle_log, { buffer = true, noremap = true })
    end
  })

  -- Markdown 配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      -- 基础设置
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.expandtab = true
      vim.opt_local.smarttab = true

      -- Markdown编辑快捷键
      local opts = { buffer = true }
      
      -- 模板导航
      vim.keymap.set("i", ",f", "<Esc>/<++><CR>:nohlsearch<CR>\"_c4l", opts)
      vim.keymap.set("i", "<c-e>", "<Esc>/<++><CR>:nohlsearch<CR>\"_c4l", opts)
      vim.keymap.set("i", ",w", "<Esc>/ <++><CR>:nohlsearch<CR>\"_c5l<CR>", opts)
      
      -- 格式化快捷键
      vim.keymap.set("i", ",n", "---<Enter><Enter>", opts)
      vim.keymap.set("i", ",b", "**** <++><Esc>F*hi", opts)  -- 粗体
      vim.keymap.set("i", ",s", "~~~~ <++><Esc>F~hi", opts)  -- 删除线
      vim.keymap.set("i", ",i", "** <++><Esc>F*i", opts)     -- 斜体
      vim.keymap.set("i", ",d", "`` <++><Esc>F`i", opts)     -- 代码
      vim.keymap.set("i", ",m", "- [ ] ", opts)              -- 任务列表
      
      -- 代码块
      vim.keymap.set("i", ",c", "```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA", opts)
      
      -- 链接和图片
      vim.keymap.set("i", ",p", "![](<++>) <++><Esc>F[a", opts)  -- 图片
      vim.keymap.set("i", ",a", "[](<++>) <++><Esc>F[a", opts)   -- 链接
      
      -- 标题
      vim.keymap.set("i", ",1", "#<Space><Enter><++><Esc>kA", opts)
      vim.keymap.set("i", ",2", "##<Space><Enter><++><Esc>kA", opts)
      vim.keymap.set("i", ",3", "###<Space><Enter><++><Esc>kA", opts)
      vim.keymap.set("i", ",4", "####<Space><Enter><++><Esc>kA", opts)
      
      -- 分割线
      vim.keymap.set("i", ",l", "--------<Enter>", opts)
    end
  })

  -- ==========================================
  -- 全局自动命令
  -- ==========================================
  
  -- yabai配置文件自动重启
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = vim.fn.expand("$HOME/.config/yabai/yabairc"),
    command = "!yabai --restart-service"
  })
end

return M 