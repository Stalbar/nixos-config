{ pkgs, ... }:

let
  wallpaperTool = pkgs.awww;
  changeWallpaper = pkgs.writeShellScriptBin "change-wallpaper" ''
    set -euo pipefail

    images_dir="$HOME/Pictures/Wallpapers"

    if [ ! -d "$images_dir" ]; then
      echo "Wallpaper directory not found: $images_dir" >&2
      exit 1
    fi

    random_img="$(${pkgs.findutils}/bin/find "$images_dir" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
      | ${pkgs.coreutils}/bin/shuf -n 1)"

    if [ -z "$random_img" ]; then
      echo "No wallpapers found in $images_dir" >&2
      exit 1
    fi

    if ! ${pkgs.procps}/bin/pgrep -x awww-daemon >/dev/null 2>&1; then
      ${wallpaperTool}/bin/awww-daemon >/dev/null 2>&1 &
      sleep 0.2
    fi

    ${wallpaperTool}/bin/awww img "$random_img" \
      --transition-type none
  '';
in
{
  home.packages = [
    changeWallpaper
  ];
}
