-- Global
if vim.loop.os_uname().sysname == "mac" then
  vim.g.leader = "`"
else
  vim.g.leader = "\\"
end

require "user_functions"
require "mappings"
require "globals"
require "logging"

-- Lazy.nvim
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
	defaults = {
    version = "v10.14.6"
	},
	change_detection = {
		notify = false -- Stops blocking message in the cmd line from appearing
	},
	ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})

-- nvim-tree config disables netrw so for :GBrowse, vim-fugitive needs
-- a :Browse command to define how to open a url
if vim.fn.has("mac") then
  vim.api.nvim_create_user_command('Browse', "!xdg-open <f-args>", {})
  -- command! -nargs=1 Browse silent exe "!xdg-open ' . "<args>"
else
  vim.api.nvim_create_user_command('Browse', "!open <args>", {})
  -- command! -nargs=1 Browse silent exe "!open ' . "<args>"
end
