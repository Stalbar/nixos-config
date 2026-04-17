{ config, pkgs, ... }:

let
  generatedThemeDir = "${config.home.homeDirectory}/.config/stalbar-theme/generated";

  micScript = pkgs.writeShellScript "waybar-mic" ''
    set -eu

    status="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || true)"
    if [ -z "$status" ]; then
      echo "󰍭"
      exit 0
    fi

    if echo "$status" | ${pkgs.gnugrep}/bin/grep -q "\[MUTED\]"; then
      echo ""
      exit 0
    fi

    vol="$(echo "$status" | ${pkgs.gawk}/bin/awk '{ printf "%d", $2 * 100 }')"
    if [ "$vol" -lt 34 ]; then
      echo "󰍬"
    elif [ "$vol" -lt 67 ]; then
      echo "󰍭"
    else
      echo "󰍮"
    fi
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "right";
        width = 38;
        spacing = 4;
        margin-top = 10;
        margin-bottom = 10;
        margin-right = 6;
        margin-left = 0;

        # Vertical bar layout:
        # top = workspaces, center = tray, bottom = status icons + clock.
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "wlr/taskbar"
          "tray"
        ];
        modules-right = [
          "custom/theme"
          "pulseaudio#output"
          "custom/mic"
          "battery"
          "hyprland/language"
          "clock#stack"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          sort-by-number = true;
          format = "{id}";
        };

        "custom/theme" = {
          exec = "switch-theme --waybar-json";
          return-type = "json";
          format = "{}";
          interval = 3;
          on-click = "switch-theme --toggle";
          tooltip = true;
        };

        "pulseaudio#output" = {
          format = "{icon}";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
            headphone = "";
            headset = "";
          };
          scroll-step = 5;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          tooltip = true;
          tooltip-format = "{volume}%";
        };

        "custom/mic" = {
          exec = "${micScript}";
          interval = 2;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          tooltip = false;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-full = "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = true;
          tooltip-format = "{capacity}%";
        };

        "hyprland/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
          min-length = 2;
          tooltip = false;
        };

        tray = {
          icon-size = 18;
          spacing = 6;
          show-passive-items = true;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        "clock#stack" = {
          format = "{:%H\n%M}";
          tooltip-format = "<big>{:%A, %d %B %Y}</big>";
          interval = 1;
        };
      }
    ];

    style = ''
      @import url("file://${generatedThemeDir}/waybar-theme.css");
    '';
  };
}
