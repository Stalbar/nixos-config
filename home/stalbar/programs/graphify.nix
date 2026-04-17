{ lib, pkgs, ... }:

{
  home.activation.graphifyInstall = lib.hm.dag.entryAfter [ "installPackages" ] ''
    export PATH="${pkgs.gcc}/bin''${PATH:+:}$PATH"
    export CC="${pkgs.gcc}/bin/cc"
    UV="${pkgs.uv}/bin/uv"
    GRAPHIFY_BIN="$HOME/.local/bin/graphify"
    if [ -x "$GRAPHIFY_BIN" ]; then
      echo "[graphify] already installed; skipping boot-time install"
    else
      echo "[graphify] installing..."
      $UV tool install graphifyy || echo "[graphify] install failed; continuing Home Manager activation"
    fi
  '';
}
