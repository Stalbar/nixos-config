{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.stalbar.profiles.dev;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      podman-desktop
      kind
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
