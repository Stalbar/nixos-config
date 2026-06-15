{ pkgs, nord, ... }:
let
  hex = name: "${nord.${name}}";
  swaylockConfig = ''
    indicator
    indicator-idle-visible
    daemonize
    ignore-empty-password
    show-failed-attempts
    clock
    timestr=%H:%M
    datestr=%A, %d %B
    font=JetBrainsMono Nerd Font Mono
    font-size=56
    indicator-radius=160
    indicator-thickness=4
    screenshots
    effect-blur=3x3
    effect-vignette=0.50:0.50
    color=#${hex "nord0"}8c
    inside-color=#${hex "nord0"}8c
    inside-clear-color=#${hex "nord1"}cc
    ring-color=#${hex "nord10"}73
    ring-clear-color=#${hex "nord10"}e6
    text-color=#${hex "nord4"}f5
    text-clear-color=#${hex "nord5"}db
    key-hl-color=#${hex "nord14"}
    separator-color=#${hex "nord11"}
    line-color=#${hex "nord3"}00
    line-uses-ring
  '';
in
{
  home.packages = [ pkgs.swaylock-effects ];
  xdg.configFile."swaylock/config".text = swaylockConfig;
}
