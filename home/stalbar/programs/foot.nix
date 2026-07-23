{ config, lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono Nerd Font:size=11";
        pad = "12x12";
      };
      colors = {
        background = lib.removePrefix "#" colors.bg;
        foreground = lib.removePrefix "#" colors.fg;
        regular0 = "15161e"; # black
        regular1 = lib.removePrefix "#" colors.red;
        regular2 = lib.removePrefix "#" colors.green;
        regular3 = lib.removePrefix "#" colors.yellow;
        regular4 = lib.removePrefix "#" colors.blue;
        regular5 = lib.removePrefix "#" colors.magenta;
        regular6 = lib.removePrefix "#" colors.cyan;
        regular7 = "a9b1d6"; # white
        bright0 = "414868";
        bright1 = lib.removePrefix "#" colors.red;
        bright2 = lib.removePrefix "#" colors.green;
        bright3 = lib.removePrefix "#" colors.yellow;
        bright4 = lib.removePrefix "#" colors.blue;
        bright5 = lib.removePrefix "#" colors.magenta;
        bright6 = lib.removePrefix "#" colors.cyan;
        bright7 = "c0caf5";
      };
    };
  };
}
