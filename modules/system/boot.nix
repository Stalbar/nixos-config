{ pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "threadirqs"
    "ipv6.disable=1"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };
}
