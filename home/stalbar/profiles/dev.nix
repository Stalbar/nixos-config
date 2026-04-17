{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.stalbar.profiles.dev;
  dotnetMulti = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnet-sdk_10
    pkgs.dotnet-runtime_10
    pkgs.dotnetCorePackages.aspnetcore_10_0
    pkgs.dotnet-sdk_11
    pkgs.dotnet-runtime_11
    pkgs.dotnetCorePackages.aspnetcore_11_0
  ];
  # podman-desktop tracks Electron aggressively on unstable; keep using the binary runtime.
  podmanDesktop = pkgs.podman-desktop.override {
    electron_41 = pkgs.electron_41-bin;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      gnumake
      gcc
      pnpm
      yarn
      typescript
      typescript-language-server
      vscode-langservers-extracted
      eslint_d
      prettier
      prettierd

      python3
      python3Packages.pip
      pyright
      ruff

      go
      gopls

      dotnetMulti
      roslyn-ls
      csharpier

      lua-language-server
      bash-language-server
      yaml-language-server
      dockerfile-language-server
      protols
      qt6.qtdeclarative
      tree-sitter
      nixd
      postgres-language-server
      sqlcmd

      stylua
      shfmt
      pgformatter
      jq
      yq-go
      gh
      k6

      docker
      docker-compose
      docker-buildx
      podmanDesktop
      kind
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      k9s
      skaffold
      minikube
    ];
  };
}
