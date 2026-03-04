{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/system/base.nix
    ../../modules/system/boot.nix
    ../../modules/system/grub-theme.nix
    ../../modules/system/networking.nix
    ../../modules/system/storage.nix
    ../../modules/system/power.nix
    ../../modules/system/maintenance.nix
    ../../modules/system/snapshots.nix
    ../../modules/system/compat.nix
    ../../modules/system/security.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/login.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/nvidia.nix
    ../../modules/desktop/intel.nix
    ../../modules/packages/system.nix
  ];

  networking.hostName = "nixos";
}
