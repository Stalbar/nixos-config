{ config, pkgs, ... }:

let
  nixBin = "${config.nix.package.out}/bin";
in
{
  # Keep Nix store healthy without aggressive daily churn.
  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];
    randomizedDelaySec = "30min";
    persistent = true;
    options = "--delete-older-than 14d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
    randomizedDelaySec = "45min";
    persistent = true;
  };

  # Hard cap system generations so rollback list stays concise.
  systemd.services.nix-prune-system-generations = {
    description = "Keep only the latest 10 NixOS system generations";
    unitConfig.ConditionPathExists = "/nix/var/nix/profiles/system";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
    };
    script = ''
      set -eu

      gens_to_delete="$(
        ${nixBin}/nix-env --profile /nix/var/nix/profiles/system --list-generations \
          | ${pkgs.gawk}/bin/awk '{print $1}' \
          | ${pkgs.coreutils}/bin/sort -n \
          | ${pkgs.coreutils}/bin/head -n -10 || true
      )"

      if [ -n "$gens_to_delete" ]; then
        # shellcheck disable=SC2086
        ${nixBin}/nix-env --profile /nix/var/nix/profiles/system --delete-generations $gens_to_delete
      fi
    '';
    startAt = [ "weekly" ];
    restartIfChanged = false;
  };

  systemd.timers.nix-prune-system-generations = {
    timerConfig = {
      RandomizedDelaySec = "20min";
      Persistent = true;
    };
  };
}
