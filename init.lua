require("config.defaults")
require("config.keymaps")
require("config.plugins")

vim.api.nvim_set_keymap('o', 'L', '$', { noremap = true })
vim.api.nvim_set_keymap('o', 'H', '0', { noremap = true })
vim.cmd('source $HOME/.config/nvim/cursor_for_qwerty.vim')
vim.g.python3_host_prog = '/Users/tianli/miniforge3/bin/python'
