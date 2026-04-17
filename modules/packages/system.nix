{ config, lib, pkgs, ... }:

{
  environment.systemPackages =
    (with pkgs; [
      git
      neovim
      neovide
      curl
      wget
      ripgrep
      fd
      unzip
      zip
      pciutils
      usbutils
      btrfs-progs
      snapper
      openssl
      wireguard-tools
      bubblewrap
    ])
    ++ lib.optionals config.services.postgresql.enable [
      config.services.postgresql.package
    ];
}
