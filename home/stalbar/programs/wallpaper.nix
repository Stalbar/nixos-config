{ pkgs, ... }:

let
  wallpaperTool = pkgs.awww;
  changeWallpaper = pkgs.writeShellScriptBin "change-wallpaper" ''
    set -euo pipefail

    images_dir="$HOME/Pictures/Wallpapers"
    current_wp_file="$HOME/.config/stalbar-theme/current-wallpaper"

    mode="random"
    if [ "$#" -gt 0 ] && [ "$1" = "--reapply" ]; then
      mode="reapply"
    fi

    if [ "$mode" = "reapply" ] && [ -f "$current_wp_file" ]; then
      random_img="$(cat "$current_wp_file")"
    else
      if [ ! -d "$images_dir" ]; then
        echo "Wallpaper directory not found: $images_dir" >&2
        exit 1
      fi

      random_img="$(${pkgs.findutils}/bin/find "$images_dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        | ${pkgs.coreutils}/bin/shuf -n 1)"
    fi

    if [ -z "$random_img" ] || [ ! -f "$random_img" ]; then
      echo "No wallpaper image found" >&2
      exit 1
    fi

    # Save the original wallpaper path for future reapplies
    mkdir -p "$(dirname "$current_wp_file")"
    echo "$random_img" > "$current_wp_file"

    if ! ${pkgs.procps}/bin/pgrep -f awww-daemon >/dev/null 2>&1; then
      ${wallpaperTool}/bin/awww-daemon >/dev/null 2>&1 &
      sleep 0.2
    fi

    ${wallpaperTool}/bin/awww img "$random_img" \
      --transition-type random \
      --transition-step 15 \
      --transition-duration 2.5 \
      --transition-fps 120
  '';
in
{
  home.packages = [
    changeWallpaper
  ];
}
