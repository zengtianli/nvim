return {
	"Bekaboo/dropbar.nvim",
	config = function()
		-- 只添加一个基本的全局键位
		vim.keymap.set('n', '<Leader>b', require('dropbar.api').pick)

		-- 使用默认配置
		require("dropbar").setup({})
	end
}
