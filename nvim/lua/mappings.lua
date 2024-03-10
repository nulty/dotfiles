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
o.signcolumn = "yes"   -- allow space for signs in the gutter
o.autoread = true      -- reread the file when buffer focused
o.diffopt = "vertical" -- make diffs vertical
o.cmdheight = 2
o.scrolloff = 3
o.pumheight = 10

if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

-- Mappings
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "Jk", "<ESC>")
vim.keymap.set("n", "H", "0", { noremap = true })
vim.keymap.set("n", "L", "$", { noremap = true })
vim.keymap.set("n", "<leader>o", ":only<cr>")
vim.keymap.set("n", "<C-c>", ":bw<cr>")                                 -- delete the buffer
vim.keymap.set("n", "<leader>/", ":let @/ = ''<CR>", { silent = true }) -- Clear the search register
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')                        -- Copy to unnamed register

-- nvim-tmux-navigation in the terminal -_
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { noremap = true })

-- Tabs
vim.keymap.set("n", "Te", ":tabe<cr>")
vim.keymap.set("n", "Tc", ":tabc<cr>")
vim.keymap.set("n", "Tn", ":tabn<cr>")
vim.keymap.set("n", "Tp", ":tabp<cr>")

-- Move windows
vim.keymap.set("n", "<M-l>", ":WinShift right<cr>")
vim.keymap.set("n", "<M-k>", ":WinShift up<cr>")
vim.keymap.set("n", "<M-h>", ":WinShift left<cr>")
vim.keymap.set("n", "<M-j>", ":WinShift down<cr>")

-- Autocommands
vim.api.nvim_create_autocmd({ "BufEnter" },
  {
    pattern = { ".env.*" },
    callback = function()
      vim.api.nvim_buf_set_option(0, "filetype", "sh")
    end,
  })
