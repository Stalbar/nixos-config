{ config, pkgs, ... }:
let
  launch-waybar = pkgs.writeShellScriptBin "launch-waybar" ''
    CONFIG_FILES="${config.xdg.configHome}/waybar/config"
    STYLE_FILE="${config.xdg.configHome}/waybar/style.css"

    trap "killall .waybar-wrapped" EXIT

    while true; do
      ${pkgs.waybar}/bin/waybar &
      
      ${pkgs.inotify-tools}/bin/inotifywait -e create,modify $CONFIG_FILES $STYLE_FILE
      
      killall .waybar-wrapped
    done
  '';
in
{
  home.packages = [ launch-waybar ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        height = 40;
        margin-left = 0;
        margin-right = 0;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "group/time" ];
        modules-right = [ "privacy" "hyprland/language" "group/zvuk" "group/hardware" "tray" "network" ];

        "hyprland/window" = {
          format = "{initialTitle}";
          max-length = 35;
          rewrite = { "" = "Hyprland"; "kitty" = "Terminal"; };
        };

        "hyprland/language" = {
          format = "<span color=\"#f6c177\"></span>  {}"; # Gold
          format-en = "EN";
          format-ru = "RU";
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
          persistent-workspaces = { "1" = "1"; "2" = "2"; "3" = "3"; "4" = "4"; "5" = "5"; "6" = "6"; };
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [ "cpu" "memory" "battery" ];
        };

        cpu = { format = "<span color=\"#ebbcba\"></span>  {usage}%"; tooltip = false; }; # Rose
        memory = { format = "<span color=\"#9ccfd8\"></span>  {percentage}%"; }; # Foam
        battery = {
          format = "<span color=\"#f6c177\">{icon}</span>  {capacity}%"; # Gold
          format-icons = [ "" "" "" "" "" ];
        };

        "group/zvuk" = {
          orientation = "horizontal";
          modules = [ "pulseaudio#output" "pulseaudio#input" ];
        };

        "pulseaudio#output" = {
          format = "<span color=\"#31748f\">{icon}</span>  {volume}%"; # Pine
          format-muted = " ";
          format-icons = { headphone = ""; default = [ "" "" "" ]; };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "pulseaudio#input" = {
          format = "<span color=\"#31748f\"></span> {volume}%";
          format-source-muted = " ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        "group/time" = { modules = [ "clock" "clock#simple" ]; orientation = "horizontal"; };
        "clock#simple" = { format = "{:%H:%M:%S}"; tooltip = false; interval = 1; };
        clock = {
          format = "{:L%a %d, %b %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        network = {
          format-wifi = "<span color=\"#f6c177\"> </span>";
          format-ethernet = "<span color=\"#f6c177\"> </span>";
          format-disconnected = "⚠";
          tooltip = false;
        };
        tray = { spacing = 10; };
      };
    };

    style = ''
      /* Rose Pine Colors */
      @define-color base     #1f1d2e;
      @define-color surface  #26233a;
      @define-color overlay  #524f67;
      @define-color text     #e0def4;
      @define-color gold     #f6c177;
      @define-color rose     #ebbcba;
      @define-color pine     #31748f;
      @define-color foam     #9ccfd8;
      @define-color love     #eb6f92;

      * {
        font-family: "JetBrains Mono Nerd Font", sans-serif;
        font-size: 14px;
      }

      window#waybar {
        background-color: transparent;
      }

      window#waybar > box {
        padding: 5px 0;
      }

      /* Module Styling */
      #workspaces, #zvuk, #hardware, #time, #tray, #network, #language, #window {
        background-color: @base;
        color: @text;
        border-radius: 10px;
        padding: 2px 10px;
        margin: 0 4px;
      }

      /* High Contrast Workspaces */
      #workspaces button {
        color: @overlay;
        padding: 0 8px;
      }

      #workspaces button.active {
        color: @gold;
        background-color: @surface;
      }

      #workspaces button.urgent {
        color: @love;
      }

      /* Audio / Sound */
      #pulseaudio.output.muted, #pulseaudio.input.source-muted {
        color: @love;
      }

      /* Time Group */
      #clock.simple {
        background-color: @pine;
        color: @base;
        border-radius: 0 10px 10px 0;
        margin-left: 5px;
        padding-left: 10px;
      }

      #clock {
        padding-right: 5px;
      }

      /* Privacy Indicator */
      #privacy {
        background-color: @love;
        color: @base;
        padding: 0 10px;
        border-radius: 10px;
      }
    '';
  };
}

