local ls = require("luasnip")
local s = ls.snippet
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

  s("fn", fmta([[
const <> = (<>) => {
  <>
};
]], {
    i(1, "fnName"),
    i(2),
    i(3),
  })),

  s("expfn", fmta([[
export const <> = (<>) => {
  <>
};
]], {
    i(1, "fnName"),
    i(2),
    i(3),
  })),

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
