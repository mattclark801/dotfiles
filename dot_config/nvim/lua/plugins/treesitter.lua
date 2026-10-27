return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "sql", "python", "typst", "markdown", "markdown_inline", "bash", "lua" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
