{ config, lib, pkgs, ... }:

let
  cfg = config.stalbar.profiles.gaming;
  stalkerGammaVersion = "1.28.0";
  lutrisPkgs = pkgs.extend (_final: prev: {
    # Lutris 0.5.22 pulls OpenLDAP into its FHS environment. OpenLDAP 2.6.13
    # can fail its syncrepl integration test during local builds, so keep the
    # package code unchanged and skip only the check phase for this profile.
    openldap = prev.openldap.overrideAttrs (_old: {
      doCheck = false;
    });
  });
  stalkerGammaCli = pkgs.appimageTools.wrapType2 {
    pname = "stalker-gamma";
    version = stalkerGammaVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/FaithBeam/stalker-gamma-cli/releases/download/${stalkerGammaVersion}/stalker-gamma+linux.x64.AppImage";
      hash = "sha256-Nvlw5AubNNziAtjZ5mTb+b/ITcEipTNsDOFc9ZCZ1fQ=";
    };
    extraPkgs = pkgs: [
      pkgs.icu
    ];
  };
  gameRun = pkgs.writeShellScriptBin "game-run" ''
    exec gamemoderun nvidia-offload "$@"
  '';
  factorioLocal = pkgs.writeShellScriptBin "factorio-local" ''
    # Run Factorio on the iGPU; the PRIME offload path has been unstable here.
    exec gamemoderun "$HOME/Games/factorio/bin/x64/factorio" "$@"
  '';
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWow64Packages.stagingFull
      gameRun
      factorioLocal
      winetricks
      dxvk
      vkd3d-proton
      lutrisPkgs.lutris
      mangohud
      gamescope
      gamemode
      protonup-ng
      steam-run
      stalkerGammaCli
    ];
  };
}
