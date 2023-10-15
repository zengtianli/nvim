require("config.defaults")
require("config.keymaps")
require("config.plugins")


vim.api.nvim_set_keymap('o', 'L', '$', { noremap = true })
vim.api.nvim_set_keymap('o', 'H', '0', { noremap = true })
