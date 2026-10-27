return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    -- Load community snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    
    -- Load personal custom snippets from lua/snippets directory
    require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })
    
    local ls = require("luasnip")
    
    -- Tab to expand or jump forward through snippet placeholders
    vim.keymap.set({"i", "s"}, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
      end
    end, {silent = true})
  end,
}
