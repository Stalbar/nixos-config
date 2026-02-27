{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    ripgrep
    fd
    unzip
    zip
    pciutils
    usbutils
    btrfs-progs
    openssl
    wireguard-tools
  ];
}
