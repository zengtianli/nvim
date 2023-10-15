local M = {}

M.compile_run = function()
	vim.cmd("w")   -- 保存当前文件
	local filetype = vim.bo.filetype

	if filetype == 'c' then
		vim.cmd([[
        set splitbelow
        split
        resize -5
        term gcc % -o %< && time ./%<
        ]])
	elseif filetype == 'cpp' then
		vim.cmd([[
        set splitbelow
        !g++ -std=c++11 % -Wall -o %<
        split
        resize -15
        term ./%<
        ]])
		-- ... 使用相同的模式继续其他filetype条件

		-- 为简洁起见，我在这里省略了其他的条件。确保你添加了所有的filetype条件。
	end
end

return M

