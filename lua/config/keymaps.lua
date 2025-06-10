vim.g.mapleader = " "
vim.opt.wrap = false
local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }
local nmappings = {
	{ from = "U", to = "<c-r>" },
	{ from = "S", to = ":w<CR>" },
	{ from = "Q", to = ":q<CR>" },
	{ from = "<M-j>", to = "J", mode = { "n", "v" } },
	{ from = ";", to = ":", mode = mode_nv },
	{ from = "Y", to = "\"+y", mode = mode_v },
	{ from = "`", to = "~", mode = mode_nv },
	{ from = "K", to = "15k", mode = mode_nv },
	{ from = "J", to = "15j", mode = mode_nv },
	{ from = "W", to = "5w", mode = mode_nv },
	{ from = "B", to = "5b", mode = mode_nv },
	{ from = "H", to = "0", mode = mode_nv },
	{ from = "L", to = "$", mode = mode_nv },
	{ from = "<C-i>", to = "<c-o>", mode = mode_nv },
	{ from = "<C-o>", to = "<c-i>", mode = mode_nv },
	{ from = ",.", to = "%", mode = mode_nv },
	{ from = "<c-y>", to = "<ESC>A {}<ESC>i<CR><ESC>ko", mode = mode_i },
	{ from = "\\v", to = "v$h", },
	{ from = "<c-a>", to = "<ESC>A", mode = mode_i },
	{ from = "<leader>w", to = "<C-w>w", },
	{ from = "<leader>sk", to = "<C-w>k", },
	{ from = "<leader>sj", to = "<C-w>j", },
	{ from = "<leader>sh", to = "<C-w>h", },
	{ from = "<leader>sl", to = "<C-w>l", },
	{ from = "qf", to = "<C-w>o", },
	{ from = "s", to = "<nop>", },
	{ from = "sk", to = ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", },
	{ from = "sj", to = ":set splitbelow<CR>:split<CR>", },
	{ from = "sh", to = ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", },
	{ from = "sl", to = ":set splitright<CR>:vsplit<CR>", },
	{ from = "<up>", to = ":res +5<CR>", },
	{ from = "<down>", to = ":res -5<CR>", },
	{ from = "<left>", to = ":vertical resize-5<CR>", },
	{ from = "<right>", to = ":vertical resize+5<CR>", },
	{ from = "srh", to = "<C-w>b<C-w>K", },
	{ from = "srv", to = "<C-w>b<C-w>H", },
	{ from = "tj", to = ":tabe<CR>", },
	{ from = "tJ", to = ":tab split<CR>", },
	{ from = "th", to = ":-tabnext<CR>", },
	{ from = "tl", to = ":+tabnext<CR>", },
	{ from = "tmh", to = ":-tabmove<CR>", },
	{ from = "tml", to = ":+tabmove<CR>", },
	{ from = "<leader>sw", to = ":if &wrap | set nowrap | else | set wrap | endif<CR>" },
	{ from = "<leader><CR>", to = ":nohlsearch<CR>" },
	{ from = "<f10>", to = ":TSHighlightCapturesUnderCursor<CR>" },
	{ from = "<leader>o", to = "za" },
	{ from = "<leader>pr", to = ":profile start profile.log<CR>:profile func *<CR>:profile file *<CR>" },
	{ from = "<leader>rv", to = ":g/^[^a-zA-Z0-9\\u4e00-\\u9fa5\\[\\]\\(\\)\\{\\}*`,.;:]*$/d<CR>" },
	{ from = "<leader>rb", to = ":g/^\\s*$/d<CR>" },
	{ from = "<leader>rl", to = ":%s/\\s*$//g<CR>" },
	-- { from = "<leader>rk", to = ":%s/\\s\\+//g<CR>" },
	-- 新增：为普通模式 (n) 和可视模式 (v) 分别定义快捷键
	{ from = "<leader>rk", to = ":%s/\\s\\+//g<CR>", mode = "n", desc = "删除文件中所有多余空格" },
	{ from = "<leader>rk", to = ":s/\\s\\+//g<CR>", mode = "v", desc = "删除选中行所有多余空格" },
	{ from = "<leader>ro", to = ":g/^\\s*\\#\\s*.*$/d<CR>" },
	{ from = "<leader>v", to = ":Vista!!<CR>" },
	{ from = "<leader>mt", to = ":TableModeToggle<CR>" },
	{ from = ",v", to = "v%" },
	{ from = "<leader><esc>", to = "<nop>" },
	{ from = "R", to = ":Joshuto<CR>" },
}
for _, mapping in ipairs(nmappings) do
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
end

local function run_vim_shortcut(shortcut)
	local escaped_shortcut = vim.api.nvim_replace_termcodes(shortcut, true, false, true)
	vim.api.nvim_feedkeys(escaped_shortcut, 'n', true)
end
vim.keymap.set("n", "<leader>q", function()
	vim.cmd("TroubleClose")
	local wins = vim.api.nvim_tabpage_list_wins(0)
	if #wins > 1 then
		run_vim_shortcut([[<C-w>j:q<CR>]])
	end
end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ra', function()
	local filetype = vim.bo.filetype
	vim.cmd('w')
	if filetype == 'c' then
		vim.opt.splitbelow = true
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term gcc % -o %< && time ./%<')
	elseif filetype == 'cpp' then
		vim.opt.splitbelow = true
		-- vim.cmd('!g++ -std=c++11 % -Wall -o %<')
		vim.cmd('!clang++ -std=c++11 % -Wall -o %<')
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
		-- vim.cmd('term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .')
		vim.cmd('term node %')
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
vim.cmd [[
	autocmd BufWritePost $HOME/.config/yabai/yabairc !yabai --restart-service
]]
vim.api.nvim_set_keymap('x', '<leader>nl', [[:<C-u>lua NumberLinesFromZero()<CR>]], { noremap = true, silent = true })
function NumberLinesFromZero()
	-- Save the current cursor position
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	-- Get the start and end line numbers of the visual selection
	local start_line = vim.fn.getpos("'<")[2]
	local end_line = vim.fn.getpos("'>")[2]
	-- Calculate the offset
	local offset = start_line - 1
	-- Execute the numbering but from 00 without '. '
	vim.cmd('silent! ' .. start_line .. ',' .. end_line .. 's/^/\\=printf("%02d_", line(".") - ' .. offset .. ')/')
	-- Restore the cursor position
	vim.api.nvim_win_set_cursor(0, cursor_pos)
	vim.cmd('noh')
end

local function number_headings()
	local num1, num2, num3, num4, num5, num6 = 0, 0, 0, 0, 0, 0
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		if line:match("^# ") then
			num1 = num1 + 1
			num2, num3, num4, num5, num6 = 0, 0, 0, 0, 0
			local new_line = line:gsub("^# ", "# " .. tostring(num1) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^## ") then
			num2 = num2 + 1
			num3, num4, num5, num6 = 0, 0, 0, 0
			local new_line = line:gsub("^## ", "## " .. tostring(num1) .. "." .. tostring(num2) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^### ") then
			num3 = num3 + 1
			num4, num5, num6 = 0, 0, 0
			local new_line = line:gsub("^### ",
				"### " .. tostring(num1) .. "." .. tostring(num2) .. "." .. tostring(num3) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^#### ") then
			num4 = num4 + 1
			num5, num6 = 0, 0
			local new_line = line:gsub("^#### ",
				"#### " .. tostring(num1) .. "." .. tostring(num2) .. "." .. tostring(num3) .. "." .. tostring(num4) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^##### ") then
			num5 = num5 + 1
			num6 = 0
			local new_line = line:gsub("^##### ",
				"##### " ..
				tostring(num1) ..
				"." .. tostring(num2) .. "." .. tostring(num3) .. "." .. tostring(num4) .. "." .. tostring(num5) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^###### ") then
			num6 = num6 + 1
			local new_line = line:gsub("^###### ",
				"###### " ..
				tostring(num1) ..
				"." ..
				tostring(num2) ..
				"." .. tostring(num3) .. "." .. tostring(num4) .. "." .. tostring(num5) .. "." .. tostring(num6) .. " ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function number_h3_headings()
	local num = 0
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		if line:match("^### ") then
			num = num + 1
			local new_line = line:gsub("^### ", "### " .. tostring(num) .. ". ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function unnumber_headings()
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		if line:match("^# %d+ ") then
			local new_line = line:gsub("^# %d+ ", "# ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^## %d+%.%d+ ") then
			local new_line = line:gsub("^## %d+%.%d+ ", "## ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^### %d+%.%d+%.%d+ ") then
			local new_line = line:gsub("^### %d+%.%d+%.%d+ ", "### ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^#### %d+%.%d+%.%d+%.%d+ ") then
			local new_line = line:gsub("^#### %d+%.%d+%.%d+%.%d+ ", "#### ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^##### %d+%.%d+%.%d+%.%d+%.%d+ ") then
			local new_line = line:gsub("^##### %d+%.%d+%.%d+%.%d+%.%d+ ", "##### ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		elseif line:match("^###### %d+%.%d+%.%d+%.%d+%.%d+%.%d+ ") then
			local new_line = line:gsub("^###### %d+%.%d+%.%d+%.%d+%.%d+%.%d+ ", "###### ")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function upgrade_headings()
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		local new_line = line
		if line:match("^###### ") then
			new_line = line:gsub("^###### ", "##### ")
		elseif line:match("^##### ") then
			new_line = line:gsub("^##### ", "#### ")
		elseif line:match("^#### ") then
			new_line = line:gsub("^#### ", "### ")
		elseif line:match("^### ") then
			new_line = line:gsub("^### ", "## ")
		elseif line:match("^## ") then
			new_line = line:gsub("^## ", "# ")
		elseif line:match("^# ") then
			-- Do nothing or handle # case if needed
		end
		if new_line ~= line then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function degrade_headings()
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		local new_line = line
		if line:match("^# ") then
			new_line = line:gsub("^# ", "## ")
		elseif line:match("^## ") then
			new_line = line:gsub("^## ", "### ")
		elseif line:match("^### ") then
			new_line = line:gsub("^### ", "#### ")
		elseif line:match("^#### ") then
			new_line = line:gsub("^#### ", "##### ")
		elseif line:match("^##### ") then
			new_line = line:gsub("^##### ", "###### ")
		elseif line:match("^###### ") then
			-- You can add more levels if needed
		end
		if new_line ~= line then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function add_br_to_sentences()
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		-- 跳过标题行和空行
		if not line:match("^#+ ") and line:match("%S") then
			-- 在非空行末尾添加 <br/>
			local new_line = line:gsub("%s*$", "<br/>")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local function remove_br_from_sentences()
	for i = 1, vim.fn.line('$'), 1 do
		local line = vim.fn.getline(i)
		-- 跳过标题行
		if not line:match("^#+ ") then
			-- 移除行尾的 <br/>
			local new_line = line:gsub("<br/>%s*$", "")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end
local commands = {
	{ name = 'NumberHeadings',        func = number_headings },
	{ name = 'UnnumberHeadings',      func = unnumber_headings },
	{ name = 'AddBrToSentences',      func = add_br_to_sentences },
	{ name = 'RemoveBrFromSentences', func = remove_br_from_sentences },
	{ name = 'UpgradeHeadings',       func = upgrade_headings },
	{ name = 'DegradeHeadings',       func = degrade_headings },
	{ name = 'Numberh3headings',      func = number_h3_headings },
}
local keymaps = {
	{ keymap = '<leader>nh',  command = 'NumberHeadings' },
	{ keymap = '<leader>uh',  command = 'UnnumberHeadings' },
	{ keymap = '<leader>abs', command = 'AddBrToSentences' },
	-- { keymap = '<leader>rbs', command = 'RemoveBrFromSentences' },
	{ keymap = '<leader>ugh', command = 'UpgradeHeadings' },
	{ keymap = '<leader>dgh', command = 'DegradeHeadings' },
}
for _, cmd in ipairs(commands) do
	vim.api.nvim_create_user_command(cmd.name, cmd.func, {})
end
for _, km in ipairs(keymaps) do
	vim.api.nvim_set_keymap('n', km.keymap, ':' .. km.command .. '<CR>', { noremap = true, silent = true })
end
local function insert_blank_lines()
	-- 获取当前缓冲区的总行数
	local total_lines = vim.api.nvim_buf_line_count(0)
	-- 从第 50 行开始，每隔 50 行插入一个空行
	number = 100
	for i = number, total_lines, number do
		-- 使用 vim.api.nvim_buf_set_lines() 在指定行后插入空行
		vim.api.nvim_buf_set_lines(0, i, i, false, { "" })
	end
end
-- 将函数绑定到命令 :InsertBlankLines
vim.api.nvim_create_user_command("InsertBlankLines", insert_blank_lines, {})
-- Function to remove Python comments and docstrings using the external script
local function remove_python_comments_and_docstrings()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local source = table.concat(lines, "\n")
	-- Replace this path with the actual path to your script
	local script_path = "/Users/tianli/useful_scripts/remove_comments.py"
	-- Ensure the path is correct and the script is executable
	local cmd = { "python3", script_path }
	local result = vim.fn.system(cmd, source)
	if vim.v.shell_error ~= 0 then
		print("Error removing comments: " .. result)
		return
	end
	local new_lines = vim.split(result, "\n")
	-- Remove possible empty last line due to split
	if new_lines[#new_lines] == '' then
		table.remove(new_lines, #new_lines)
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
end
-- Create a command to run the function
vim.api.nvim_create_user_command('RemovePythonComments', remove_python_comments_and_docstrings, {})
local function remove_all_duplicates()
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local seen = {}
	local unique_lines = {}
	local total_lines = #lines
	-- 遍历所有行，只保留未见过的行
	for _, line in ipairs(lines) do
		if not seen[line] then
			seen[line] = true
			table.insert(unique_lines, line)
		end
	end
	-- 用去重后的行替换原有内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, unique_lines)
	-- 显示删除了多少行
	local removed = total_lines - #unique_lines
	print("Removed " .. removed .. " duplicate lines")
end
-- 创建命令
vim.api.nvim_create_user_command("RemoveDuplicates", remove_all_duplicates, {})
-- 可选：添加快捷键映射
-- vim.keymap.set('n', '<leader>rd', ':RemoveDuplicates<CR>', { noremap = true, silent = true })
local function remove_consecutive_duplicates()
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local unique_lines = {}
	local total_lines = #lines
	-- 遍历所有行，只有当当前行与前一行不同时才保留
	for i, line in ipairs(lines) do
		if i == 1 or line ~= lines[i - 1] then
			table.insert(unique_lines, line)
		end
	end
	-- 用去重后的行替换原有内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, unique_lines)
	-- 显示删除了多少行
	local removed = total_lines - #unique_lines
	print("Removed " .. removed .. " consecutive duplicate lines")
end
-- 创建命令
vim.api.nvim_create_user_command("RemoveConsecutiveDuplicates", remove_consecutive_duplicates, {})
local punctuation_map = {
	['，'] = ',',
	['。'] = '.',
	['？'] = '?',
	['！'] = '!',
	['：'] = ':',
	['；'] = ';',
	['"'] = '"',
	['"'] = '"',
	['「'] = '"',
	['」'] = '"',
	['（'] = '(',
	['）'] = ')',
	['【'] = '[',
	['】'] = ']',
	['《'] = '<',
	['》'] = '>',
	['…'] = '...',
	['、'] = ',',
	['～'] = '~',
	['·'] = '.',
	['『'] = '"',
	['』'] = '"',
	['〈'] = '<',
	['〉'] = '>',
	['［'] = '[',
	['］'] = ']',
	['｛'] = '{',
	['｝'] = '}'
}
local function Cn_punc2En_pun()
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local changes = 0
	-- 遍历每一行
	for _, line in ipairs(lines) do
		local modified_line = line
		-- 对每个中文标点进行替换
		for cn_punct, en_punct in pairs(punctuation_map) do
			local count
			modified_line, count = modified_line:gsub(cn_punct, en_punct)
			changes = changes + count
		end
		table.insert(modified_lines, modified_line)
	end
	-- 用转换后的内容替换原有内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
	-- 显示转换数量
	print("Converted " .. changes .. " Chinese punctuation marks to English")
end
-- 创建命令
vim.api.nvim_create_user_command("Cnpunc2Enpun", Cn_punc2En_pun, {})
local punctuation_map = {
	['，'] = ',',
	['。'] = '.',
	['？'] = '?',
	['！'] = '!',
	['：'] = ':',
	['；'] = ';',
	['"'] = '"',
	['"'] = '"',
	['「'] = '"',
	['」'] = '"',
	['（'] = '(',
	['）'] = ')',
	['【'] = '[',
	['】'] = ']',
	['《'] = '<',
	['》'] = '>',
	['…'] = '...',
	['、'] = ',',
	['～'] = '~',
	['·'] = '.',
	['『'] = '"',
	['』'] = '"',
	['〈'] = '<',
	['〉'] = '>',
	['［'] = '[',
	['］'] = ']',
	['｛'] = '{',
	['｝'] = '}'
}

-- 创建反向映射表(英文到中文)
local reverse_punctuation_map = {}
for cn, en in pairs(punctuation_map) do
	reverse_punctuation_map[en] = cn
end

local function toggle_CNEN_punc()
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- 统计中英文标点数量以决定转换方向
	local cn_count, en_count = 0, 0
	for _, line in ipairs(lines) do
		for cn_punct, _ in pairs(punctuation_map) do
			cn_count = cn_count + select(2, line:gsub(cn_punct, ""))
		end

		for en_punct, _ in pairs(reverse_punctuation_map) do
			-- 转义特殊字符
			local pattern = en_punct:gsub("([%%%[%]%(%)%.%*%+%-%?%^%$])", "%%%1")
			en_count = en_count + select(2, line:gsub(pattern, ""))
		end
	end

	-- 根据标点数量确定转换方向
	local is_cn_to_en = cn_count >= en_count
	local map_to_use = is_cn_to_en and punctuation_map or reverse_punctuation_map
	local modified_lines = {}
	local changes = 0

	-- 执行转换
	for _, line in ipairs(lines) do
		local modified_line = line
		for from_punct, to_punct in pairs(map_to_use) do
			local count
			-- 转义特殊字符
			local pattern = from_punct:gsub("([%%%[%]%(%)%.%*%+%-%?%^%$])", "%%%1")
			modified_line, count = modified_line:gsub(pattern, to_punct)
			changes = changes + count
		end
		table.insert(modified_lines, modified_line)
	end

	-- 更新缓冲区内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)

	-- 显示转换结果
	local direction = is_cn_to_en and "中文到英文" or "英文到中文"
	print("已转换 " .. changes .. " 个标点符号（" .. direction .. "）")
end
-- 创建命令
vim.api.nvim_create_user_command("ToggleCNEPunc", toggle_CNEN_punc, {})

local function pad_numbers()
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local changes = 0
	-- 遍历每一行
	for _, line in ipairs(lines) do
		-- 使用 gsub 查找 G 后面的数字并补零
		local modified_line = line:gsub("G(%d+)", function(num)
			local padded_num = string.format("%03d", tonumber(num))
			changes = changes + 1
			return "G" .. padded_num
		end)
		table.insert(modified_lines, modified_line)
	end
	-- 用转换后的内容替换原有内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
	-- 显示转换数量
	print("Padded " .. changes .. " numbers with zeros")
end
-- 创建命令
vim.api.nvim_create_user_command("PadNumbers", pad_numbers, {})

local function unpad_numbers()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local total_changes = 0

	-- 遍历每一行
	for _, line in ipairs(lines) do
		-- line:gsub 的第二个返回值是它执行的替换次数
		local modified_line, changes_in_line = line:gsub("G(%d+)", function(num_str)
			-- tonumber("007") 会得到数字 7
			-- tostring(7) 会得到字符串 "7"
			-- 这样就自然地去掉了前导零
			local unpadded_num = tostring(tonumber(num_str))

			-- 如果原始字符串和处理后的字符串不同，才算一次有效的修改
			-- (这一步其实可以省略，因为即使 G5 -> G5，用户通常也期望看到 "0 changes" 的结果)
			-- 我们主要依赖 gsub 返回的替换次数
			return "G" .. unpadded_num
		end)

		-- 累加这一行发生的替换次数
		total_changes = total_changes + changes_in_line
		table.insert(modified_lines, modified_line)
	end

	-- 仅当确实有变化时才修改缓冲区并显示消息
	if total_changes > 0 then
		-- 用转换后的内容替换原有内容
		vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
		-- 使用 vim.notify 显示消息，比 print 更好
		vim.notify("Unpadded " .. total_changes .. " numbers.", vim.log.levels.INFO)
	else
		vim.notify("No padded numbers found to unpad.", vim.log.levels.INFO)
	end
end

-- 创建用户命令 :UnpadNumbers
vim.api.nvim_create_user_command("UnpadNumbers", unpad_numbers, {})


local function perform_math_operation(operation, operand)
	-- 获取当前缓冲区的所有行
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local changes = 0
	-- 检查是否提供了有效的操作和操作数
	if not operation or not operand then
		print("Usage: :PerformMathOperation [operation] [operand]")
		print("Example: :PerformMathOperation divide 365")
		return
	end
	-- 转换操作数为数值
	local op_value = tonumber(operand)
	if not op_value then
		print("Error: operand must be a number")
		return
	end
	-- 遍历每一行
	for _, line in ipairs(lines) do
		-- 使用 gsub 查找数值并对其执行运算
		local modified_line = line:gsub("(%d+%.?%d*)", function(number_str)
			local num = tonumber(number_str)
			if num then
				local result
				-- 执行指定的运算
				if operation == "divide" then
					result = num / op_value
				elseif operation == "multiply" then
					result = num * op_value
				elseif operation == "add" then
					result = num + op_value
				elseif operation == "subtract" then
					result = num - op_value
				else
					-- 如果操作不被识别，保持原值
					return number_str
				end
				changes = changes + 1
				-- 格式化结果，保留2位小数
				return string.format("%.2f", result)
			else
				-- 如果无法转换为数值，保持原值
				return number_str
			end
		end)
		table.insert(modified_lines, modified_line)
	end
	-- 用转换后的内容替换原有内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
	-- 显示转换数量
	print("Modified " .. changes .. " numbers")
end
-- 创建命令，接受两个参数：操作类型和操作数
vim.api.nvim_create_user_command("PerformMathOperation", function(opts)
	local args = vim.split(opts.args, " ")
	perform_math_operation(args[1], args[2])
end, {
	nargs = "+",
	complete = function(_, _, _)
		return { "divide", "multiply", "add", "subtract" }
	end
})
function convert_to_markdown_headings()
	-- Get all lines in the current buffer
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = {}

	for _, line in ipairs(lines) do
		-- Match patterns like "1.", "1.1.", "1.1.1.", etc.
		local prefix, content = line:match("^([%d%.]+)(.*)$")

		if prefix then
			local depth = select(2, prefix:gsub("%.", ""))

			-- Create the markdown heading with appropriate number of #
			local heading_prefix = string.rep("#", depth) .. " "
			table.insert(result, heading_prefix .. content:gsub("^%s*", ""))
		else
			-- If no numbered prefix found, keep the line unchanged
			table.insert(result, line)
		end
	end

	-- Replace the buffer content with the result
	vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
end

-- Command to execute the function
vim.api.nvim_create_user_command('NumberedToMarkdown', function()
	convert_to_markdown_headings()
end, {})
