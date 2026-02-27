{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    fastfetch
    kdePackages.okular
    obsidian
    pavucontrol
    libreoffice
    telegram-desktop
    transmission_4-gtk
    thunar
    thunar-volman
    thunar-archive-plugin
    tumbler
    grim
    slurp
    grimblast
    wl-clipboard
    gowall
    qt6.qtwayland
    qt6.qtimageformats
    kdePackages.kio
    kdePackages.kio-extras
    eza
    bat
    trash-cli
  ];
}
