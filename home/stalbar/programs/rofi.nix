{ pkgs, nord, ... }:

{
  home.packages = [
    pkgs.rofi
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Papirus-Dark";
      drun-display-format: "{name}";
      display-drun: "Apps";
      display-run: "Run";
      display-window: "Windows";
      terminal: "kitty";
      font: "JetBrainsMono Nerd Font Mono 13";
      hover-select: true;
      me-select-entry: "";
      me-accept-entry: "MousePrimary";
    }

    @theme "~/.config/rofi/nordic.rasi"
  '';

  xdg.configFile."rofi/nordic.rasi".text = ''
    * {
      bg: #${nord.nord0}F2;
      bg-alt: #${nord.nord1};
      fg: #${nord.nord4};
      fg-dim: #${nord.nord3};
      accent: #${nord.nord9};
      selected: #${nord.nord10};
      urgent: #${nord.nord11};
      border-col: #${nord.nord3};
      border-radius: 10px;
      spacing: 10px;
    }

    window {
      width: 760px;
      height: 560px;
      location: center;
      anchor: center;
      fullscreen: false;
      padding: 16px;
      border: 1px;
      border-color: @border-col;
      border-radius: @border-radius;
      background-color: @bg;
    }

    mainbox {
      spacing: 12px;
      children: [ "inputbar", "listview" ];
      background-color: transparent;
    }

    inputbar {
      padding: 10px 12px;
      spacing: 10px;
      border: 1px;
      border-color: @border-col;
      border-radius: 8px;
      background-color: @bg-alt;
      children: [ "prompt", "entry" ];
    }

    prompt {
      text-color: @accent;
      background-color: transparent;
    }

    entry {
      placeholder: "Search";
      placeholder-color: @fg-dim;
      text-color: @fg;
      background-color: transparent;
    }

    listview {
      lines: 9;
      columns: 1;
      fixed-height: true;
      cycle: true;
      dynamic: false;
      scrollbar: false;
      layout: vertical;
      spacing: 6px;
      background-color: transparent;
    }

    element {
      padding: 10px 12px;
      border: 0;
      border-radius: 8px;
      background-color: transparent;
      text-color: @fg;
    }

    element normal.normal {
      background-color: transparent;
      text-color: @fg;
    }

    element normal.urgent {
      background-color: transparent;
      text-color: @urgent;
    }

    element selected.normal {
      background-color: @selected;
      text-color: #${nord.nord6};
    }

    element selected.urgent {
      background-color: @urgent;
      text-color: #${nord.nord6};
    }

    element-icon {
      size: 1.2em;
      background-color: transparent;
    }

    element-text {
      vertical-align: 0.5;
      text-color: inherit;
      background-color: transparent;
    }
  '';
}
