{ ... }:

{
  imports = [
    ./base.nix
    ./boot.nix
    ./keyboard.nix
    ./grub-theme.nix
    ./networking.nix
    ./storage.nix
    ./power.nix
    ./maintenance.nix
    ./snapshots.nix
    ./compat.nix
    ./security.nix
    ./virtualization.nix
  ];
}
