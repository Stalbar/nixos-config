local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s("imp", fmta([[import { <> } from "<>";]], {
    i(1, "name"),
    i(2, "module"),
  })),

  s("imd", fmta([[import <> from "<>";]], {
    i(1, "name"),
    i(2, "module"),
  })),

s("fn", {
    t("const "),
    i(1, "fnName"),
    t(" = ("),
    i(2),
    t({ ") => {", "  " }),
    i(3),
    t({ "", "};" }),
  }),

s("expfn", {
    t("export const "),
    i(1, "fnName"),
    t(" = ("),
    i(2),
    t({ ") => {", "  " }),
    i(3),
    t({ "", "};" }),
  }),

  s("iface", fmta([[
interface <> {
  <>
}
]], {
    i(1, "TypeName"),
    i(2),
  })),

  s("clg", fmta([[console.log(<>);]], {
    i(1, "value"),
  })),
}
