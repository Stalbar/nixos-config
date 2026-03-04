{ pkgs, ... }:

{
  # Compatibility layer for non-Nix bundled binaries (game repacks/installers).
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
      gtk3
      gdk-pixbuf
      pango
      cairo
      atk
      libGL
      libglvnd
      vulkan-loader
      alsa-lib
      libpulseaudio
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      xorg.libxcb
      xorg.libXfixes
      xorg.libxshmfence
      xorg.libXdamage
      xorg.libXcomposite
      xorg.libXxf86vm
      xorg.libSM
      xorg.libICE
      dbus
      fontconfig
      freetype
      expat
      libdrm
      wayland
    ];
  };
}
