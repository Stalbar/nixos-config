{ pkgs, ... }:

let
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

    if ! ${pkgs.procps}/bin/pgrep -x swww-daemon >/dev/null 2>&1; then
      ${pkgs.swww}/bin/swww-daemon >/dev/null 2>&1 &
      sleep 0.2
    fi

    transitions=(fade left right top bottom wipe grow center outer wave)
    transition="''${transitions[$((RANDOM % ''${#transitions[@]}))]}"

    x_pos="0.$((RANDOM % 90 + 10))$((RANDOM % 900 + 100))"
    y_pos="0.$((RANDOM % 90 + 10))$((RANDOM % 900 + 100))"

    ${pkgs.swww}/bin/swww img "$random_img" \
      --transition-step 5 \
      --transition-fps 120 \
      --transition-type "$transition" \
      --transition-pos "$x_pos,$y_pos"
  '';
in
{
  home.packages = [
    changeWallpaper
  ];
}
