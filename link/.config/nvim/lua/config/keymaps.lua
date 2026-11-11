-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "gH", function()
  vim.cmd("normal! H")
end, { desc = "Top of screen" })

vim.keymap.set("n", "gM", function()
  vim.cmd("normal! M")
end, { desc = "Middle of screen" })

vim.keymap.set("n", "gL", function()
  vim.cmd("normal! L")
end, { desc = "Bottom of screen" })
