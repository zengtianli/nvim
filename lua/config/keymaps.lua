vim.g.mapleader = " "

local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }
local nmappings = {
	{ from = "U",             to = "<c-r>" },
	{ from = "S",             to = ":w<CR>" },
	{ from = "Q",             to = ":q<CR>" },
	{ from = ";",             to = ":",                                                                   mode = mode_nv },
	{ from = "Y",             to = "\"+y",                                                                mode = mode_v },
	{ from = "`",             to = "~",                                                                   mode = mode_nv },

	-- Movement
	{ from = "K",             to = "15k",                                                                 mode = mode_nv },
	{ from = "J",             to = "15j",                                                                 mode = mode_nv },
	{ from = "H",             to = "0",                                                                   mode = mode_nv },
	{ from = "L",             to = "$",                                                                   mode = mode_nv },
	{ from = "<C-i>",         to = "<c-o>",                                                               mode = mode_nv },
	{ from = "<C-o>",         to = "<c-i>",                                                               mode = mode_nv },



	-- Useful actions
	{ from = ",.",            to = "%",                                                                   mode = mode_nv },
	{ from = "<c-y>",         to = "<ESC>A {}<ESC>i<CR><ESC>ko",                                          mode = mode_i },
	{ from = "\\v",           to = "v$h", },
	{ from = "<c-a>",         to = "<ESC>A",                                                              mode = mode_i },

	-- Window & splits
	{ from = "<leader>w",     to = "<C-w>w", },
	{ from = "<leader>sk",    to = "<C-w>k", },
	{ from = "<leader>sj",    to = "<C-w>j", },
	{ from = "<leader>sh",    to = "<C-w>h", },
	{ from = "<leader>sl",    to = "<C-w>l", },
	{ from = "qf",            to = "<C-w>o", },
	{ from = "s",             to = "<nop>", },
	{ from = "sk",            to = ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", },
	{ from = "sj",            to = ":set splitbelow<CR>:split<CR>", },
	{ from = "sh",            to = ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", },
	{ from = "sl",            to = ":set splitright<CR>:vsplit<CR>", },
	{ from = "<up>",          to = ":res +5<CR>", },
	{ from = "<down>",        to = ":res -5<CR>", },
	{ from = "<left>",        to = ":vertical resize-5<CR>", },
	{ from = "<right>",       to = ":vertical resize+5<CR>", },
	{ from = "srh",           to = "<C-w>b<C-w>K", },
	{ from = "srv",           to = "<C-w>b<C-w>H", },

	-- Tab management
	{ from = "tj",            to = ":tabe<CR>", },
	{ from = "tJ",            to = ":tab split<CR>", },
	{ from = "th",            to = ":-tabnext<CR>", },
	{ from = "tl",            to = ":+tabnext<CR>", },
	{ from = "tmh",           to = ":-tabmove<CR>", },
	{ from = "tml",           to = ":+tabmove<CR>", },

	-- Other
	-- { from = "<leader>sw",    to = ":set wrap<CR>" },
	{ from = "<leader>sw",    to = ":if &wrap | set nowrap | else | set wrap | endif<CR>" },
	{ from = "<leader><CR>",  to = ":nohlsearch<CR>" },
	{ from = "<f10>",         to = ":TSHighlightCapturesUnderCursor<CR>" },
	{ from = "<leader>o",     to = "za" },
	{ from = "<leader>pr",    to = ":profile start profile.log<CR>:profile func *<CR>:profile file *<CR>" },
	{ from = "<leader>rc",    to = ":e ~/.config/nvim/init.lua<CR>" },
	{ from = "<leader>rv",    to = ":e .vim.lua<CR>" },
	{ from = ",v",            to = "v%" },
	{ from = "<leader><esc>", to = "<nop>" },

	-- Joshuto
	{ from = "R",             to = ":Joshuto<CR>" },
}

for _, mapping in ipairs(nmappings) do
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
end

local function run_vim_shortcut(shortcut)
	local escaped_shortcut = vim.api.nvim_replace_termcodes(shortcut, true, false, true)
	vim.api.nvim_feedkeys(escaped_shortcut, 'n', true)
end

-- close win below
vim.keymap.set("n", "<leader>q", function()
	vim.cmd("TroubleClose")
	local wins = vim.api.nvim_tabpage_list_wins(0)
	if #wins > 1 then
		run_vim_shortcut([[<C-w>j:q<CR>]])
	end
end, { noremap = true, silent = true })
-- Define the mapping in normal mode
vim.keymap.set('n', '<leader>ra', function()
	-- Save the current buffer
	local filetype = vim.bo.filetype
	vim.cmd('w')
	if filetype == 'c' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term gcc % -o %< && time ./%<')
	elseif filetype == 'cpp' then
		vim.opt.splitbelow = true
		vim.cmd('!g++ -std=c++11 % -Wall -o %<')
		vim.cmd('sp')
		vim.cmd('res -15')
		vim.cmd('term ./%<')
	elseif filetype == 'cs' then
		vim.opt.splitbelow = true
		vim.cmd('silent! !mcs %')
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term mono %<.exe')
	elseif filetype == 'java' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term javac % && time java %<')
	elseif filetype == 'sh' then
		vim.cmd('!time bash %')
	elseif filetype == 'python' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('term python3 %')
	elseif filetype == 'html' then
		vim.cmd('silent! !' .. vim.g.mkdp_browser .. ' % &')
	elseif filetype == 'markdown' then
		vim.cmd('InstantMarkdownPreview')
	elseif filetype == 'tex' then
		vim.cmd('silent! VimtexStop')
		vim.cmd('silent! VimtexCompile')
	elseif filetype == 'dart' then
		vim.cmd('CocCommand flutter.run -d ' .. vim.g.flutter_default_device .. ' ' .. vim.g.flutter_run_args)
		vim.cmd('silent! CocCommand flutter.dev.openDevLog')
	elseif filetype == 'javascript' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .')
	elseif filetype == 'racket' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term racket %')
	elseif filetype == 'go' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('term go run .')
	end
end, { noremap = true, silent = true })
-- change 'autocmd BufWritePost $HOME/.config/yabai/yabairc !yabai --restart-service'
vim.cmd [[
	autocmd BufWritePost $HOME/.config/yabai/yabairc !yabai --restart-service
	" autocmd BufWritePost *.swift !swift build
]]
-- Remove all blank lines in the file
vim.api.nvim_set_keymap('n', '<LEADER>rb', ':g/^\\s*$/d<CR>', { noremap = true, silent = true })

-- Remove trailing whitespaces in the file
vim.api.nvim_set_keymap('n', '<LEADER>rl', ':%s/\\s*$//g<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<LEADER>ro', ':g/^--\\s*.*$/d<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<LEADER>ro', ':g/^\\s*--\\s*.*$/d<CR>', { noremap = true, silent = true })
