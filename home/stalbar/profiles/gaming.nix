{ config, lib, pkgs, ... }:

let
  cfg = config.stalbar.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWow64Packages.stagingFull
      winetricks
      dxvk
      vkd3d-proton
      lutris
      heroic
      mangohud
      gamescope
      gamemode
      protonup-ng
    ];
  };
}
