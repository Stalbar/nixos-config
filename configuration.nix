{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  
  system.stateVersion = "25.11";
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Minsk";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [ "threadirqs" ];
  
  users.users.stalbar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    cores = 0;
    max-jobs = "auto";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    ripgrep fd
    unzip zip
    btop
    pciutils
    usbutils
    btrfs-progs
    openssl
  ];

  virtualisation.docker.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
  services.irqbalance.enable = true;
  
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  services.fstrim.enable = true;

  services.xserver.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
