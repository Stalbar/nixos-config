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

  kbScript = pkgs.writeShellScript "waybar-kb-layout" ''
    set -eu

    layout=""

    if command -v hyprctl >/dev/null 2>&1 && pgrep -x Hyprland >/dev/null 2>&1; then
      layout=$(hyprctl devices -j 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep -oP '"active_keymap":\s*"\K[^"]+' | head -1 || true)
    fi

    if [ -z "$layout" ] && command -v niri >/dev/null 2>&1 && pgrep -x niri >/dev/null 2>&1; then
      layout=$(niri msg inputs 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep -i "active.*layout" | head -1 | \
        ${pkgs.gnused}/bin/sed 's/.*: *//' || true)
    fi

    case "$layout" in
      "English (US)")         echo '{"text":"EN","tooltip":"English (US)"}' ;;
      "Russian")              echo '{"text":"RU","tooltip":"Russian"}' ;;
      "English (US, alt. intl.)") echo '{"text":"EN","tooltip":"English (US)"}' ;;
      *)                      echo "{\"text\":\"\",\"tooltip\":\"$layout\"}" ;;
    esac
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

        modules-left = [
          "hyprland/workspaces"
          "wlr/workspaces"
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
          "custom/language"
          "clock#stack"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          sort-by-number = true;
          format = "{id}";
        };

        "wlr/workspaces" = {
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

        "custom/language" = {
          exec = "${kbScript}";
          return-type = "json";
          format = "{}";
          interval = 1;
          on-click = "wlr-layout-switcher next 2>/dev/null || true";
          tooltip = true;
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
