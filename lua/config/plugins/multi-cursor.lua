-- multi-cursor.lua
return {
	"mg979/vim-visual-multi",
	init = function()
		vim.cmd([[
		noremap <leader>sa <Plug>(VM-Select-All)
]])
	end
}
