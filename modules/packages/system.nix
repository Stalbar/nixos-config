{
  config,
  lib,
  pkgs,
  ...
}:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      geist-font
      noto-fonts-color-emoji
      symbola
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrains Mono Nerd Font" ];
        sansSerif = [ "Geist" "Inter" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment.systemPackages =
    (with pkgs; [
      git
      fish
      foot
      neovim
      neovide
      zoxide
      libnotify
      imagemagick
      nh
      sops
      curl
      wget
      ripgrep
      fd
      unzip
      zip
      pciutils
      usbutils
      btrfs-progs
      openssl
      wireguard-tools
      bubblewrap

      # Language Servers & Formatters
      nixd
      nixfmt
      gopls
      go
      lua-language-server
      bash-language-server
      pyright
      ruff
      typescript-language-server
      vscode-langservers-extracted
      tree-sitter
      stylua
      shfmt
      prettierd
    ])
    ++ lib.optionals config.services.postgresql.enable [
      config.services.postgresql.package
    ]
    ++ lib.optionals config.services.neo4j.enable [
      config.services.neo4j.package
    ];
}
