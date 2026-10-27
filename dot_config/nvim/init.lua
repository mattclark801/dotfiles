-- 1. Basic Settings
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true

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

-- 4. Load Plugins and Configure LSPs
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "sqlls", "tinymist" }
      })
      
      -- Modern Neovim 0.11+ way to start language servers
      vim.lsp.enable("pyright")
      vim.lsp.enable("sqlls")
      vim.lsp.enable("tinymist")
    end,
  }
})
