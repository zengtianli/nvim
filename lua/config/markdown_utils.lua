local M = {}

-- 给标题自动编号
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

-- 给三级标题编号
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

-- 取消标题编号
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

-- 升级标题级别（减少#）
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
		end
		if new_line ~= line then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end

-- 降级标题级别（增加#）
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
		end
		if new_line ~= line then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end

-- 添加换行标签到句子末尾
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

-- 移除换行标签
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

-- 将数字编号转换为Markdown标题
function M.convert_to_markdown_headings()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = {}

	for _, line in ipairs(lines) do
		-- 匹配像 "1.", "1.1.", "1.1.1." 这样的模式
		local prefix, content = line:match("^([%d%.]+)(.*)$")

		if prefix then
			local depth = select(2, prefix:gsub("%.", ""))
			-- 创建对应层级的Markdown标题
			local heading_prefix = string.rep("#", depth) .. " "
			table.insert(result, heading_prefix .. content:gsub("^%s*", ""))
		else
			-- 如果没有找到数字前缀，保持行不变
			table.insert(result, line)
		end
	end

	-- 用结果替换缓冲区内容
	vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
end

-- 设置命令和键映射
function M.setup()
	local commands = {
		{ name = 'NumberHeadings',        func = number_headings,        desc = "给标题编号" },
		{ name = 'UnnumberHeadings',      func = unnumber_headings,      desc = "取消标题编号" },
		{ name = 'AddBrToSentences',      func = add_br_to_sentences,    desc = "添加换行标签" },
		{ name = 'RemoveBrFromSentences', func = remove_br_from_sentences, desc = "移除换行标签" },
		{ name = 'UpgradeHeadings',       func = upgrade_headings,       desc = "升级标题级别" },
		{ name = 'DegradeHeadings',       func = degrade_headings,       desc = "降级标题级别" },
		{ name = 'Numberh3headings',      func = number_h3_headings,     desc = "给三级标题编号" },
		{ name = 'NumberedToMarkdown',    func = M.convert_to_markdown_headings, desc = "将数字编号转换为Markdown标题" },
	}

	local keymaps = {
		{ keymap = '<leader>nh',  command = 'NumberHeadings',    desc = "给标题编号" },
		{ keymap = '<leader>uh',  command = 'UnnumberHeadings',  desc = "取消标题编号" },
		{ keymap = '<leader>abs', command = 'AddBrToSentences',  desc = "添加换行标签" },
		{ keymap = '<leader>ugh', command = 'UpgradeHeadings',   desc = "升级标题级别" },
		{ keymap = '<leader>dgh', command = 'DegradeHeadings',   desc = "降级标题级别" },
	}

	-- 创建命令
	for _, cmd in ipairs(commands) do
		vim.api.nvim_create_user_command(cmd.name, cmd.func, {})
	end

	-- 创建键映射
	for _, km in ipairs(keymaps) do
		vim.api.nvim_set_keymap('n', km.keymap, ':' .. km.command .. '<CR>', 
			{ noremap = true, silent = true, desc = km.desc })
	end
end

return M 