{ lib, ... }:

{
  imports = [
    ./profiles/default.nix
  ];

  options.stalbar.profiles = {
    dev.enable = lib.mkEnableOption "development package profile";
    gaming.enable = lib.mkEnableOption "gaming package profile";
  };

  # Keep current behavior; disable per profile in home.nix when needed.
  config = {
    stalbar.profiles.dev.enable = lib.mkDefault true;
    stalbar.profiles.gaming.enable = lib.mkDefault true;
  };
}
