vim.g.mapleader = " "
local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Quit Insert Mode" })

map({ "n", "v", "o" }, "gh", "^", { desc = "To the start of the line" })
map({ "n", "v", "o" }, "gl", "$", { desc = "To the end of the line" })

map("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Unhighlight" })

map("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "Lazy" })
