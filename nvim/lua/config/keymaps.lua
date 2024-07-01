-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_del_keymap("n", "<A-j>")
vim.api.nvim_del_keymap("n", "<A-k>")
vim.api.nvim_del_keymap("i", "<A-j>")
vim.api.nvim_del_keymap("i", "<A-k>")
vim.api.nvim_del_keymap("v", "<A-j>")
vim.api.nvim_del_keymap("v", "<A-k>")
