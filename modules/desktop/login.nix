{ pkgs, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  hyprlandSession = "start-hyprland";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --time-format '%A, %B %d %H:%M' --greeting 'NixOS Hyprland Workstation' --asterisks --remember --window-padding 2 --container-padding 2 --prompt '󰌾 user: ' --theme 'border=bb9af7;title=7dcfff;greeting=7dcfff;textbox=c0caf5;button=bb9af7;prompt=7dcfff' --cmd ${hyprlandSession}";
        user = "greeter";
      };
    };
  };

  # Avoid getty conflict on tty1
  services.getty.helpLine = "";
}
