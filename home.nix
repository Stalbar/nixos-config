{ config, pkgs, ...}: {
  imports = [
    ./modules/home/git.nix
    ./modules/home/zsh.nix
    ./modules/home/hyprland.nix
  ];

  home.username = "stalbar";
  home.homeDirectory = "/home/stalbar";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    firefox
    kitty
  ];
}
