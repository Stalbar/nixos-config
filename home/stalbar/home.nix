{ ... }:

{
  imports = [
    ./programs/default.nix
  ];

  home.username = "stalbar";
  home.homeDirectory = "/home/stalbar";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
