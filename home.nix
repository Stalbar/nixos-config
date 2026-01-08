{ config, pkgs, ...}: {
  imports = [
    ./modules/home/git.nix
    ./modules/home/zsh.nix
    ./modules/home/hyprland.nix
    ./modules/home/kitty.nix
    ./modules/home/fastfetch.nix
    ./modules/home/starship.nix
    ./modules/home/waybar.nix
    ./modules/home/rofi.nix
    ./modules/home/btop.nix
  ];

  home.username = "stalbar";
  home.homeDirectory = "/home/stalbar";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    firefox
    kitty
    nerd-fonts.jetbrains-mono
    grimblast
    swappy
  ];
  fonts.fontconfig.enable = true;
}
