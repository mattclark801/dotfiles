return {
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-ui",
    },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- Safely hook into your autocomplete engine (nvim-cmp)
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        cmp.setup.filetype({ "sql" }, {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "luasnip" },
            { name = "buffer" },
          },
        })
      end
    end,
  }
}
