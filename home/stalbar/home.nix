{ ... }:

{
  imports = [
    ./packages.nix
    ./theme/nord.nix
    ./programs/default.nix
  ];

  home.username = "stalbar";
  home.homeDirectory = "/home/stalbar";
  home.stateVersion = "25.11";

  stalbar.profiles = {
    dev.enable = true;
    gaming.enable = true;
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
