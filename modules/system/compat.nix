{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  systemd.tmpfiles.rules = [
    # Antigravity currently probes /usr/bin/bwrap; expose the system bubblewrap there.
    "L+ /usr/bin/bwrap - - - - ${pkgs.bubblewrap}/bin/bwrap"
  ];
}
