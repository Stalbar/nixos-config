{ ... }:

{
  imports = [
    ./packages.nix
    ./theme/nord.nix
    ./programs/theme.nix
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/kitty.nix
    ./programs/firefox.nix
    ./programs/waybar.nix
    ./programs/wallpaper.nix
    ./programs/hyprland.nix
  ];

  home.username = "stalbar";
  home.homeDirectory = "/home/stalbar";
  home.stateVersion = "25.11";

  stalbar.profiles = {
    dev.enable = true;
    gaming.enable = true;
  };

  programs.home-manager.enable = true;
}
