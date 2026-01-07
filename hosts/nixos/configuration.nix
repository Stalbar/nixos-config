{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/system/tlp/default.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Minsk";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.stalbar = {
    isNormalUser = true;
    description = "aleksey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
  ];

  system.stateVersion = "25.11"; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
  programs.git.enable = true;

  programs.zsh.enable = true;
  users.users.stalbar.shell = pkgs.zsh;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  specialisation = {
    gaming.configuration = {
      imports = [ ../../modules/system/tlp/gaming.nix ];
    };
    boost.configuration = {
      imports = [ ../../modules/system/tlp/gaming-boost.nix ];
    };
  };
  
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  securityy.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
