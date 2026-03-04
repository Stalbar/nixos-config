{ pkgs, ... }:

let
  grubNordTheme = pkgs.runCommand "grub-theme-nord-minimal" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    theme_dir="$out/grub-theme"
    mkdir -p "$theme_dir"

    # Opaque background only (no alpha) to avoid firmware/GRUB color glitches.
    ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:'#3B4252-#2E3440' \
      -fill '#434C5E' -draw "polygon 0,820 360,620 740,820 1120,640 1540,840 1920,700 1920,1080 0,1080" \
      -fill '#3B4252' -draw "polygon 0,910 280,760 610,910 920,780 1260,930 1610,790 1920,920 1920,1080 0,1080" \
      -fill '#2E3440' -draw "polygon 0,980 250,860 540,980 860,840 1220,1000 1540,870 1920,990 1920,1080 0,1080" \
      -alpha off -type TrueColor \
      "$theme_dir/background.jpg"

    cat > "$theme_dir/theme.txt" <<'EOF'
desktop-image: "background.jpg"
desktop-color: "#2E3440"
terminal-left: "0"
terminal-top: "0"
terminal-width: "100%"
terminal-height: "100%"
terminal-border: "0"

+ label {
  top = 10%
  left = 0
  width = 100%
  align = "center"
  text = "NixOS Boot Menu"
  color = "#ECEFF4"
  font = "Unifont Regular 18"
}

+ boot_menu {
  left = 27%
  top = 24%
  width = 46%
  height = 52%
  item_font = "Unifont Regular 20"
  item_color = "#D8DEE9"
  selected_item_color = "#ECEFF4"
  item_height = 42
  item_spacing = 6
  item_padding = 8
  scrollbar = false
}

+ label {
  top = 88%
  left = 0
  width = 100%
  align = "center"
  text = "Use ↑ ↓ to select, Enter to boot."
  color = "#D8DEE9"
  font = "Unifont Regular 16"
}
EOF
  '';
in
{
  boot.loader.grub = {
    gfxmodeEfi = "auto";
    theme = "${grubNordTheme}/grub-theme";
    extraConfig = ''
      set color_normal=white/black
      set color_highlight=white/black
      set menu_color_normal=white/black
      set menu_color_highlight=white/black
    '';
  };
}
