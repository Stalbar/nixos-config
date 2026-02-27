{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    fastfetch
    kitty
    firefox
    telegram-desktop
    transmission_4-gtk
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.tumbler
    grim
    slurp
    grimblast
    wl-clipboard
    gowall
    qt6.qtwayland
    qt6.qtimageformats
    kdePackages.breeze-icons
    kdePackages.kio
    kdePackages.kio-extras
    codex
  ];
}
