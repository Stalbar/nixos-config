{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages =
    (with pkgs; [
      git
      neovim
      neovide
      curl
      wget
      ripgrep
      fd
      unzip
      zip
      pciutils
      usbutils
      btrfs-progs
      snapper
      openssl
      efibootmgr
      os-prober
      wireguard-tools
      bubblewrap

      # factorio runtime deps (SDL display backends)
      libxscrnsaver
      libxkbcommon
      libxcb
      libx11
      libxcursor
      libxi
      libxrandr
      libxext
      wayland
    ])
    ++ lib.optionals config.services.postgresql.enable [
      config.services.postgresql.package
    ]
    ++ lib.optionals config.services.neo4j.enable [
      config.services.neo4j.package
    ];
}
