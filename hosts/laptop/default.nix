{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
    ../../modules/desktop/default.nix
    ../../modules/packages/system.nix
  ];

  networking.hostName = "nixos";
}
