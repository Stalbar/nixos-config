{ pkgs, ... }:

{
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
}
