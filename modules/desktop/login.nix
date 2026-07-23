{ pkgs, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  hyprlandSession = "${pkgs.hyprland}/bin/Hyprland";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd ${hyprlandSession}";
        user = "greeter";
      };
    };
  };

  # Avoid getty conflict on tty1
  services.getty.helpLine = "";
}
