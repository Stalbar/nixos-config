{ config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      source = "${config.home.homeDirectory}/.config/stalbar-theme/generated/hyprlock-theme.conf";

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
          color = "$lock_surface";
          rounding = 14;
          border_size = 1;
          border_color = "$lock_border";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
          color = "$lock_time";
          font_size = 56;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "0, 180";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +'%A, %d %B')\"";
          color = "$lock_date";
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
          outer_color = "$lock_input_outer";
          inner_color = "$lock_input_inner";
          font_color = "$lock_input_font";
          placeholder_text = "Password";
          check_color = "$lock_check";
          fail_color = "$lock_fail";
          fail_text = "$FAIL ($ATTEMPTS)";
          hide_input = false;
          position = "0, -82";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
