{ nord, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      background = "#${nord.nord0}";
      foreground = "#${nord.nord4}";
      selection_background = "#${nord.nord2}";
      selection_foreground = "#${nord.nord6}";
      cursor = "#${nord.nord4}";
      color0 = "#${nord.nord1}";
      color1 = "#${nord.nord11}";
      color2 = "#${nord.nord14}";
      color3 = "#${nord.nord13}";
      color4 = "#${nord.nord9}";
      color5 = "#${nord.nord15}";
      color6 = "#${nord.nord8}";
      color7 = "#${nord.nord5}";
      color8 = "#${nord.nord3}";
      color9 = "#${nord.nord11}";
      color10 = "#${nord.nord14}";
      color11 = "#${nord.nord13}";
      color12 = "#${nord.nord9}";
      color13 = "#${nord.nord15}";
      color14 = "#${nord.nord7}";
      color15 = "#${nord.nord6}";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };
}
