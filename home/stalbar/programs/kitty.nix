{ nord, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 12;
    };
    
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";

      text_composition_strategy = "platform";
      font_features = "JetBrainsMonoNerdFontMono +liga +calt";
      box_drawing_scale = "0.001, 1, 1.5, 2";

      window_margin_width = 6;
      single_window_margin_width = 4;
      window_padding_width = 10;
      window_border_width = 2;

      active_border_color = "#${nord.nord10}";
      inactive_border_color = "#${nord.nord3}";

      wayland_titlebar_color = "system";

      background_opacity = "0.90";
      dynamic_background_opacity = "yes";
      inactive_text_alpha = "0.92";

      foreground = "#${nord.nord4}";
      background = "#${nord.nord0}";

      cursor = "#${nord.nord6}";
      cursor_text_color = "#${nord.nord0}";
      cursor_shape = "beam";
      cursor_beam_thickness = "1.8";
      cursor_trail = 8;
      cursor_trail_decay = "0.08 0.22";
      cursor_trail_start_threshold = 1;

      scrollback_lines = 20000;
      wheel_scroll_multiplier = "2.0";
      touch_scroll_multiplier = "1.0";

      url_color = "#${nord.nord8}";
      underline_hyperlinks = "always";

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "top";
      tab_bar_margin_width = 10;
      tab_bar_margin_height = "6 6";
      tab_title_template = "{index}: {title}";

      active_tab_foreground = "#${nord.nord0}";
      active_tab_background = "#${nord.nord15}";
      inactive_tab_foreground = "#${nord.nord4}";
      inactive_tab_background = "#${nord.nord1}";
      tab_bar_background = "#${nord.nord0}";
      tab_separator = "  ";

      enable_audio_bell = "no";
      visual_bell_duration = 0;
      bell_border_color = "#${nord.nord12}";

      selection_background = "#${nord.nord0}";
      selection_foreground = "#${nord.nord8}";

      color0 = "#${nord.nord1}";
      color8 = "#${nord.nord3}";
      color1 = "#${nord.nord11}";
      color9 = "#${nord.nord11}";
      color2 = "#${nord.nord14}";
      color10 = "#${nord.nord14}";
      color3 = "#${nord.nord13}";
      color11 = "#${nord.nord13}";
      color4 = "#${nord.nord9}";
      color12 = "#${nord.nord10}";
      color5 = "#${nord.nord15}";
      color13 = "#${nord.nord15}";
      color6 = "#${nord.nord8}";
      color14 = "#${nord.nord7}";
      color7 = "#${nord.nord5}";
      color15 = "#${nord.nord6}";

      enable_layouts = "tail,*";

      input_delay = 0;
      repaint_delay = 8;
      sync_to_monitor = "no";
      linux_display_server = "wayland";

      confirm_os_window_close = 0;
    };

    keybindings = {
      "f1" = "launch --cwd=current";
      "f2" = "new_tab_with_cwd";
      "ctrl+left" = "resize_window narrower";
      "ctrl+right" = "resize_window wider";
      "ctrl+up" = "resize_window taller";
      "ctrl+down" = "resize_window shorter 3";
      "ctrl+home" = "resize_window reset";
    };
  };
}
