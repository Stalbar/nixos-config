local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s("nmod", fmta([[
{ config, lib, pkgs, ... }:

{
  <>
}
]], {
    i(1),
  })),

  s("mkif", fmta([[
lib.mkIf <> {
  <>
};
]], {
    i(1, "condition"),
    i(2),
  })),

  s("mken", fmta([[<> = lib.mkEnableOption "<>";]], {
    i(1, "feature"),
    i(2, "Enable feature"),
  })),

  s("mkopt", fmta([[
<> = lib.mkOption {
  type = lib.types.<>;
  default = <>;
  description = "<>";
};
]], {
    i(1, "myOption"),
    i(2, "str"),
    i(3, "\"\""),
    i(4, "Description"),
  })),

  s("pkg", fmta([[pkgs.<>]], {
    i(1, "packageName"),
  })),
}
