{ lib, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    systemd.enable = true;

    settings = {
      theme = "stalbar-runtime";

      "font-family" = "JetBrainsMono Nerd Font Mono";
      "font-family-bold" = "JetBrainsMono Nerd Font Mono";
      "font-family-italic" = "JetBrainsMono Nerd Font Mono";
      "font-family-bold-italic" = "JetBrainsMono Nerd Font Mono";
      "font-size" = 12;
      "font-feature" = [
        "+liga"
        "+calt"
      ];

      "cursor-style" = "bar";
      "cursor-style-blink" = false;
      "mouse-hide-while-typing" = true;
      "mouse-scroll-multiplier" = 2.0;
      "scrollback-limit" = 20971520;

      "window-padding-x" = 4;
      "window-padding-y" = 4;
      "window-padding-balance" = true;
      "window-padding-color" = "background";
      "window-decoration" = "none";
      "window-show-tab-bar" = "auto";
      "window-inherit-working-directory" = true;
      "tab-inherit-working-directory" = true;
      "split-inherit-working-directory" = true;
      "window-inherit-font-size" = true;

      "background-opacity-cells" = true;
      "unfocused-split-opacity" = 0.92;
      "split-preserve-zoom" = true;

      "confirm-close-surface" = false;
      "quit-after-last-window-closed" = true;
      "quit-after-last-window-closed-delay" = "5m";
      "app-notifications" = "no-clipboard-copy,config-reload";

      keybind = [
        "f1=new_window"
        "f2=new_tab"
        "ctrl+shift+r=reload_config"
        "ctrl+shift+enter=new_split:auto"
        "ctrl+shift+backspace=toggle_split_zoom"
      ];
    };
  };

  # The runtime theme switcher owns ~/.config/ghostty/themes/stalbar-runtime.
  # Home Manager's on-change validation can run before that runtime file exists.
  xdg.configFile."ghostty/config".onChange = lib.mkForce "";
}
