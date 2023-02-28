-- Options
local o = vim.o

o.number = true
o.splitbelow = true
o.splitright = true
o.noswapfile = true
o.nobackup = true
o.smartcase = true
o.ignorecase = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.showmatch = true
o.signcolumn = "yes" -- allow space for signs in the gutter
o.autoread = true -- reread the file when buffer focused
o.diffopt = "vertical" -- reread the file when buffer focused
o.cmdheight = 2
o.scrolloff = 3

if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

-- Mappings
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "Jk", "<ESC>")
vim.keymap.set("n", "H", "0", { noremap = true })
vim.keymap.set("n", "L", "$", { noremap = true })
vim.keymap.set("n", "<leader>o", ":only<cr>")
vim.keymap.set("n", "<C-c>", ":bw<cr>") -- delete the buffer
vim.keymap.set("n", "<leader>/", ":let @/ = ''<CR>") -- Clear the search register
