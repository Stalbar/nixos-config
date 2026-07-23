{ pkgs, ... }:

let
  wallpaperTool = pkgs.awww;
  changeWallpaper = pkgs.writeShellScriptBin "change-wallpaper" ''
    set -euo pipefail

    images_dir="$HOME/Pictures/Wallpapers"
    current_wp_file="$HOME/.config/stalbar-theme/current-wallpaper"

    mkdir -p "$images_dir"

    mode="random"
    if [ "$#" -gt 0 ] && [ "$1" = "--reapply" ]; then
      mode="reapply"
    fi

    if [ "$mode" = "reapply" ] && [ -f "$current_wp_file" ] && [ -s "$current_wp_file" ]; then
      random_img="$(cat "$current_wp_file")"
    else
      random_img="$(${pkgs.findutils}/bin/find "$images_dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null \
        | ${pkgs.coreutils}/bin/shuf -n 1 || true)"
    fi

    if [ -z "$random_img" ] || [ ! -f "$random_img" ]; then
      default_wp="$images_dir/tokyo-night-default.png"
      if [ ! -f "$default_wp" ]; then
        ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:'#1a1b26-#16161e' \
          -fill '#24283b' -draw "polygon 0,820 360,620 740,820 1120,640 1540,840 1920,700 1920,1080 0,1080" \
          -fill '#1f2335' -draw "polygon 0,910 280,760 610,910 920,780 1260,930 1610,790 1920,920 1920,1080 0,1080" \
          -stroke '#7dcfff' -strokewidth 2 -fill none -draw "circle 960,540 960,340" \
          -alpha off -type TrueColor "$default_wp"
      fi
      random_img="$default_wp"
    fi

    mkdir -p "$(dirname "$current_wp_file")"
    echo "$random_img" > "$current_wp_file"

    if ! ${pkgs.procps}/bin/pgrep -f awww-daemon >/dev/null 2>&1; then
      ${wallpaperTool}/bin/awww-daemon >/dev/null 2>&1 &
      sleep 0.3
    fi

    ${wallpaperTool}/bin/awww img "$random_img" \
      --transition-type random \
      --transition-step 15 \
      --transition-duration 2.0 \
      --transition-fps 120
  '';
in
{
  home.packages = [
    changeWallpaper
    wallpaperTool
  ];

  # Auto-apply wallpaper on session startup
  systemd.user.services.set-wallpaper = {
    Unit = {
      Description = "Set Tokyo Night Wallpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${changeWallpaper}/bin/change-wallpaper --reapply";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
