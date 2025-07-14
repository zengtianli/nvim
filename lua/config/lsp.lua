-- ==========================================
-- 统一LSP配置
-- ==========================================

local M = {}
local F = {}
local documentation_window_open = false

-- LSP相关工具函数
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local limitStr = function(str)
  if #str > 25 then
    str = string.sub(str, 1, 22) .. "..."
  end
  return str
end

local dartColonFirst = function(entry1, entry2)
  if vim.bo.filetype ~= "dart" then return nil end
  local entry1EndsWithColon = string.find(entry1.completion_item.label, ":") and entry1.source.name == 'nvim_lsp'
  local entry2EndsWithColon = string.find(entry2.completion_item.label, ":") and entry2.source.name == 'nvim_lsp'
  if entry1EndsWithColon and not entry2EndsWithColon then
    return true
  elseif not entry1EndsWithColon and entry2EndsWithColon then
    return false
  end
  return nil
end

local moveCursorBeforeComma = function()
  if vim.bo.filetype ~= "dart" then return end
  vim.defer_fn(function()
    local line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local char = line:sub(col - 2, col)
    if char == ": ," then
      vim.api.nvim_win_set_cursor(0, { row, col - 1 })
    end
  end, 100)
end

-- Flutter预览堆栈跟踪
local preview_stack_trace = function()
  local line = vim.api.nvim_get_current_line()
  local pattern = "package:[^/]+/([^:]+):(%d+):(%d+)"
  local filepath, line_nr, column_nr = string.match(line, pattern)
  if filepath and line_nr and column_nr then
    vim.cmd(":wincmd k")
    vim.cmd("e " .. filepath)
    vim.api.nvim_win_set_cursor(0, { tonumber(line_nr), tonumber(column_nr) })
    vim.cmd(":wincmd j")
  end
end

-- 配置文档和签名
F.configureDocAndSignature = function()
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      focusable = false,
      border = "rounded",
      zindex = 60,
    }
  )
  local group = vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
      if not documentation_window_open then
        vim.diagnostic.open_float(0, {
          scope = "cursor",
          focusable = false,
          zindex = 10,
          close_events = {
            "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre",
            "InsertEnter", "WinLeave", "ModeChanged"
          },
        })
      end
    end,
    group = group,
  })
end

-- 配置文档显示
local documentation_window_open_index = 0
local function show_documentation()
  documentation_window_open_index = documentation_window_open_index + 1
  local current_index = documentation_window_open_index
  documentation_window_open = true
  vim.defer_fn(function()
    if current_index == documentation_window_open_index then
      documentation_window_open = false
    end
  end, 500)
  vim.lsp.buf.hover()
end

-- 配置LSP键绑定
F.configureKeybinds = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
      local opts = { buffer = event.buf, noremap = true, nowait = true }
      vim.keymap.set('n', '<leader>h', show_documentation, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', ':tab sp<CR><cmd>lua vim.lsp.buf.definition()<cr>', opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('i', '<c-f>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>aw', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', "<leader>,", vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>t', ':Trouble<cr>', opts)
      vim.keymap.set('n', '<leader>-', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', '<leader>=', vim.diagnostic.goto_next, opts)
    end
  })
end

-- 签名配置
F.signature_config = {}

-- LSP主配置
M = {
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      {
        "folke/trouble.nvim",
        opts = {
          use_diagnostic_signs = true,
          action_keys = { close = "<esc>" },
        },
      },
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = function() vim.cmd([[MasonInstall]]) end,
      },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'j-hui/fidget.nvim', tag = "legacy" },
      "folke/neodev.nvim",
      "ray-x/lsp_signature.nvim",
      "ldelossa/nvim-dap-projects",
      "airblade/vim-rooter",
      "b0o/schemastore.nvim",
      {
        'laytan/tailwind-sorter.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
        build = 'cd formatter && npm ci && npm run build',
        opts = { on_save_enabled = true }
      },
    },
    config = function()
      local lsp = require('lsp-zero').preset({})
      M.lsp = lsp
      
      -- Mason设置
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          "biome", "cssls", 'ts_ls', 'eslint', 'gopls', 'jsonls', 'html',
          'clangd', 'dockerls', 'ansiblels', 'terraformls', 'texlab',
          'pyright', 'yamlls', 'tailwindcss', 'taplo', "prismals"
        }
      })

      -- LSP attach配置
      lsp.on_attach(function(client, bufnr)
        if client.name == "ts_ls" and vim.bo[bufnr].filetype ~= "javascript" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
        lsp.default_keymaps({ buffer = bufnr })
        client.server_capabilities.semanticTokensProvider = nil
        
        -- 配置自动补全
        require("config.autocomplete").setup()
        require("lsp_signature").on_attach(F.signature_config, bufnr)
        
        vim.diagnostic.config({
          severity_sort = true, underline = true, signs = true,
          virtual_text = false, update_in_insert = false, float = true
        })
        lsp.set_sign_icons({
          error = '✘', warn = '▲', hint = '⚑', info = '»'
        })
      end)

      lsp.set_server_config({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      lsp.format_on_save({ format_opts = {} })

      local lspconfig = require('lspconfig')

      -- Lua LSP配置
      require("neodev").setup({ lspconfig = true, override = function() end })
      lspconfig.lua_ls.setup({
        on_attach = function() end,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim', 'require' } },
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" }
          }
        }
      })

      -- JSON LSP配置
      lspconfig.jsonls.setup({ on_attach = function() end })

      -- Flutter LSP配置
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "__FLUTTER_DEV_LOG__",
        callback = function()
          vim.keymap.set("n", "p", preview_stack_trace, { silent = true, noremap = true, buffer = true })
        end
      })
      
      local dart_lsp = lsp.build_options('dartls', {})
      local flutter = require('flutter-tools')
      flutter.setup({
        fvm = true,
        widget_guides = { enabled = true },
        ui = { border = "rounded", notification_style = 'nvim-notify' },
        lsp = {
          on_attach = function()
            vim.cmd('highlight! link FlutterWidgetGuides Comment')
          end,
          capabilities = dart_lsp.capabilities,
          settings = {
            enableSnippets = false, showTodos = true, completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand '$HOME/.pub-cache',
              vim.fn.expand '$HOME/fvm',
            },
            lineLength = vim.g.flutter_format_line_length,
          },
        },
        dev_log = {
          enabled = true, notify_errors = true,
          open_cmd = "botright 40vnew",
        },
        debugger = {
          enabled = true, run_via_dap = true,
          exception_breakpoints = {
            {
              filter = 'raised', label = 'Exceptions',
              condition = "!(url:startsWith('package:flutter/') || url:startsWith('package:flutter_test/') || url:startsWith('package:dartpad_sample/') || url:startsWith('package:flutter_localizations/'))"
            }
          },
          register_configurations = function(_)
            local dap = require("dap")
            if not dap.configurations.dart then
              dap.adapters.dart = {
                type = "executable", command = "flutter", args = { "debug_adapter" }
              }
              dap.configurations.dart = {
                {
                  type = "dart", request = "launch", name = "Launch Flutter Program",
                  program = "lib/main.dart", cwd = "${workspaceFolder}",
                  toolArgs = { "-d", "macos" }
                }
              }
            end
            require("dap.ext.vscode").load_launchjs()
          end,
        },
      })

      -- 其他LSP服务器配置
      require 'lspconfig'.html.setup {}
      require 'lspconfig'.pyright.setup {}
      require 'lspconfig'.tailwindcss.setup {}
      require 'lspconfig'.ts_ls.setup {}
      require 'lspconfig'.biome.setup {}
      require 'lspconfig'.cssls.setup {}
      require 'lspconfig'.taplo.setup {}
      require 'lspconfig'.ansiblels.setup {}
      require 'lspconfig'.terraformls.setup {}
      require 'lspconfig'.prismals.setup {}

      -- TeX配置
      require 'lspconfig'.texlab.setup {
        texlab = {
          bibtexFormatter = "texlab",
          build = {
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            executable = "latexmk", forwardSearchAfter = false, onSave = true
          },
          chktex = { onEdit = false, onOpenAndSave = false },
          diagnosticsDelay = 300, formatterLineLength = 80,
          forwardSearch = { args = {} },
          latexFormatter = "latexindent",
          latexindent = { modifyLineBreaks = false }
        }
      }

      -- YAML配置
      require 'lspconfig'.yamlls.setup({
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            schemaStore = { enable = false, url = "" },
            validate = false,
            customTags = {
              "!fn", "!And", "!If", "!Not", "!Equals", "!Or", "!FindInMap sequence",
              "!Base64", "!Cidr", "!Ref", "!Sub", "!GetAtt", "!GetAZs",
              "!ImportValue", "!Select", "!Split", "!Join sequence"
            }
          }
        }
      })

      require 'lspconfig'.gopls.setup {}
      lsp.setup()

      -- 自动格式化配置
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*.tf", "*.tfvars", "*.lua" },
        callback = function() vim.lsp.buf.format() end,
      })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.hcl" },
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filename = vim.api.nvim_buf_get_name(bufnr)
          vim.fn.system(string.format("packer fmt %s", vim.fn.shellescape(filename)))
          vim.cmd("edit!")
        end,
      })

      -- 折叠支持
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false, lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers()
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({ capabilities = capabilities })
      end

      require("fidget").setup({})
      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force', lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      require('nvim-dap-projects').search_project_config()
      F.configureDocAndSignature()
      F.configureKeybinds()

      -- 格式化文件类型配置
      local format_on_save_filetypes = {
        dart = true, json = true, go = true, lua = true, html = true, css = true,
        javascript = true, typescript = true, typescriptreact = true,
        c = true, cpp = true, objc = true, objcpp = true,
        dockerfile = true, terraform = false, tex = true, toml = true, prisma = true
      }
      
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          if format_on_save_filetypes[vim.bo.filetype] then
            local lineno = vim.api.nvim_win_get_cursor(0)
            vim.lsp.buf.format({ async = false })
            pcall(vim.api.nvim_win_set_cursor, 0, lineno)
          end
        end,
      })
    end
  },
}

return M 