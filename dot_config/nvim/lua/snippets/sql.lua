local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("cte", fmt([[
  WITH {cte_name} AS (
      SELECT 
          {columns}
      FROM {table_name}
      WHERE {condition}
  )
  SELECT * FROM {cte_name};
  ]], {
    cte_name = i(1, "filtered_data"),
    columns = i(2, "col1, col2"),
    table_name = i(3, "schema.table_name"),
    condition = i(4, "1 = 1"),
  })),
}, {}
