local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s("cw", fmta([[Console.WriteLine(<>);]], {
    i(1, "\"message\""),
  })),

  s("cwi", fmta([[Console.WriteLine($"<>");]], {
    i(1, "{value}"),
  })),

  s("prop", fmta([[public <> <> { get; set; }]], {
    i(1, "string"),
    i(2, "Name"),
  })),

  s("ctor", fmta([[
public <>(<>)
{
    <>
}
]], {
    i(1, "ClassName"),
    i(2),
    i(3),
  })),

  s("class", fmta([[
public class <>
{
    public <>()
    {
        <>
    }
}
]], {
    i(1, "ClassName"),
    rep(1),
    i(2),
  })),

  s("tryc", fmta([[
try
{
    <>
}
catch (Exception ex)
{
    <>
}
]], {
    i(1),
    i(2, "Console.Error.WriteLine(ex);"),
  })),
}
