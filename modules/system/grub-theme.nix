{ pkgs, ... }:

let
  grubTokyoNightTheme = pkgs.runCommand "grub-theme-tokyo-night" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    theme_dir="$out/grub-theme"
    mkdir -p "$theme_dir"

    # Tokyo Night Neon gradient background (#1a1b26 base, #24283b layered accents)
    ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:'#1a1b26-#16161e' \
      -fill '#24283b' -draw "polygon 0,820 360,620 740,820 1120,640 1540,840 1920,700 1920,1080 0,1080" \
      -fill '#1f2335' -draw "polygon 0,910 280,760 610,910 920,780 1260,930 1610,790 1920,920 1920,1080 0,1080" \
      -fill '#1a1b26' -draw "polygon 0,980 250,860 540,980 860,840 1220,1000 1540,870 1920,990 1920,1080 0,1080" \
      -alpha off -type TrueColor \
      "$theme_dir/background.jpg"

    cat > "$theme_dir/theme.txt" <<'EOF'
desktop-image: "background.jpg"
desktop-color: "#1a1b26"
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
  text = "NixOS • Tokyo Night Neon"
  color = "#7dcfff"
  font = "Unifont Regular 20"
}

+ boot_menu {
  left = 27%
  top = 26%
  width = 46%
  height = 50%
  item_font = "Unifont Regular 20"
  item_color = "#c0caf5"
  selected_item_color = "#7dcfff"
  item_height = 42
  item_spacing = 8
  item_padding = 10
  scrollbar = false
}

+ label {
  top = 88%
  left = 0
  width = 100%
  align = "center"
  text = "Use ↑ ↓ to select, Enter to boot"
  color = "#565f89"
  font = "Unifont Regular 16"
}
EOF
  '';
in
{
  boot.loader.grub = {
    gfxmodeEfi = "auto";
    theme = "${grubTokyoNightTheme}/grub-theme";
    extraConfig = ''
      set color_normal=white/black
      set color_highlight=cyan/black
      set menu_color_normal=white/black
      set menu_color_highlight=cyan/black
    '';
  };
}
