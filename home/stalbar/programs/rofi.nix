{ pkgs, ... }:

{
  home.packages = [
    pkgs.rofi
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      drun-display-format: "{name}";
      display-drun: "Apps";
      display-run: "Run";
      display-window: "Windows";
      terminal: "ghostty";
      font: "JetBrainsMono Nerd Font Mono 13";
      hover-select: true;
      me-select-entry: "";
      me-accept-entry: "MousePrimary";
    }

    @theme "~/.config/stalbar-theme/generated/rofi-theme.rasi"
  '';
}
