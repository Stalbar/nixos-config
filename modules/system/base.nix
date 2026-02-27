{ pkgs, ...}:

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

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
