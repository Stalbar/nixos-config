{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/system/base.nix
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/storage.nix
    ../../modules/system/power.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/nvidia.nix
    ../../modules/desktop/intel.nix
    ../../modules/packages/system.nix
  ];

  networking.hostName = "nixos";
}
