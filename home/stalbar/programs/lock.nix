{ nord, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 1;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 1;
          blur_size = 3;
          noise = 0.01;
          contrast = 0.92;
          brightness = 0.72;
          vibrancy = 0.06;
          vibrancy_darkness = 0.20;
        }
      ];

      shape = [
        {
          monitor = "";
          size = "420, 190";
          color = "rgba(46, 52, 64, 0.55)";
          rounding = 14;
          border_size = 1;
          border_color = "rgba(129, 161, 193, 0.45)";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
          color = "rgba(236, 239, 244, 0.96)";
          font_size = 56;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "0, 180";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +'%A, %d %B')\"";
          color = "rgba(216, 222, 233, 0.86)";
          font_size = 15;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "0, 136";
          halign = "center";
          valign = "center";
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "320, 48";
          outline_thickness = 2;
          dots_size = 0.18;
          dots_spacing = 0.30;
          dots_center = true;
          fade_on_empty = false;
          outer_color = "rgba(129, 161, 193, 0.90)";
          inner_color = "rgba(59, 66, 82, 0.80)";
          font_color = "rgb(216, 222, 233)";
          placeholder_text = "Password";
          check_color = "rgb(163, 190, 140)";
          fail_color = "rgb(191, 97, 106)";
          fail_text = "$FAIL ($ATTEMPTS)";
          hide_input = false;
          position = "0, -82";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 600;
          "on-timeout" = "hyprlock";
        }
        {
          timeout = 900;
          "on-timeout" = "hyprctl dispatch dpms off";
          "on-resume" = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
