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
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Core language/runtime toolchains.
      nodejs
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

      # .NET 10 LTS + .NET 11 in one merged package to avoid bin/dotnet collisions.
      dotnetMulti
      roslyn-ls
      csharpier

      lua-language-server
      bash-language-server
      yaml-language-server
      dockerfile-language-server
      tailwindcss-language-server
      protols
      qt6.qtdeclarative
      tree-sitter
      nixd
      postgres-language-server

      # Formatters and CLI helpers.
      stylua
      shfmt
      pgformatter
      jq
      yq-go

      # Docker/Kubernetes/kind workflow.
      docker
      docker-compose
      docker-buildx
      podman-desktop
      kind
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      k9s
      skaffold
      minikube

      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
