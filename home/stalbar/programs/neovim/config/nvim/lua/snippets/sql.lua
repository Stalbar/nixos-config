local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s("sel", fmta([[
SELECT <>
FROM <>
WHERE <>;
]], {
    i(1, "*"),
    i(2, "table_name"),
    i(3, "condition"),
  })),

  s("ins", fmta([[
INSERT INTO <> (<>)
VALUES (<>);
]], {
    i(1, "table_name"),
    i(2, "column1, column2"),
    i(3, "value1, value2"),
  })),

  s("upd", fmta([[
UPDATE <>
SET <>
WHERE <>;
]], {
    i(1, "table_name"),
    i(2, "column = value"),
    i(3, "condition"),
  })),

  s("del", fmta([[
DELETE FROM <>
WHERE <>;
]], {
    i(1, "table_name"),
    i(2, "condition"),
  })),

  s("cte", fmta([[
WITH <> AS (
  <>
)
SELECT <>
FROM <>;
]], {
    i(1, "cte_name"),
    i(2, "SELECT * FROM table_name"),
    i(3, "*"),
    i(4, "cte_name"),
  })),
}
