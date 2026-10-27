-- 1. Basic Settings
vim.opt.clipboard = "unnamedplus"

-- 2. Keybindings
vim.keymap.set("i", "jk", "<Esc>")

-- 3. Install the "Lazy" Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. Start Lazy and Install Plugins
require("lazy").setup({
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
})
