{ lib, pkgs, ...}:

{
  system.stateVersion = "25.11";

  time.timeZone = "Europe/Minsk";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

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

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    source-code-pro
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font Mono" "Symbols Nerd Font Mono" ];
    sansSerif = [ "JetBrainsMono Nerd Font Mono" ];
    serif = [ "JetBrainsMono Nerd Font Mono" ];
    emoji = [ "Noto Color Emoji" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  virtualisation.docker.daemon.settings = {
    mtu = 1400;
  };
  systemd.sockets.docker.wantedBy = lib.mkForce [ ];

  programs.gamemode.enable = true;

  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
