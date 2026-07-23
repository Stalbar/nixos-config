{ pkgs, ... }:

let
  plymouthTokyoNightTheme = pkgs.runCommand "plymouth-theme-tokyo-night" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    theme_dir="$out/share/plymouth/themes/tokyo-night"
    mkdir -p "$theme_dir"

    # Neon Cyan circle logo
    ${pkgs.imagemagick}/bin/convert -size 240x240 xc:none \
      -stroke "#7dcfff" -strokewidth 10 -fill none \
      -draw "circle 120,120 120,38" \
      -stroke "#bb9af7" -strokewidth 2 -fill none \
      -draw "circle 120,120 120,58" \
      "$theme_dir/logo.png"

    # Neon Green loading dot
    ${pkgs.imagemagick}/bin/convert -size 16x16 xc:none \
      -fill "#9ece6a" -draw "circle 8,8 8,1" \
      "$theme_dir/dot.png"

    cat > "$theme_dir/tokyo-night.plymouth" <<EOF
[Plymouth Theme]
Name=Tokyo Night Neon
Description=Tokyo Night Neon splash theme
ModuleName=script

[script]
ImageDir=$theme_dir
ScriptFile=$theme_dir/tokyo-night.script
EOF

    cat > "$theme_dir/tokyo-night.script" <<'EOF'
Window.SetBackgroundTopColor(0.10, 0.11, 0.15);
Window.SetBackgroundBottomColor(0.10, 0.11, 0.15);

logo_image = Image("logo.png");
dot_image = Image("dot.png");

logo = Sprite(logo_image);
dot1 = Sprite(dot_image);
dot2 = Sprite(dot_image);
dot3 = Sprite(dot_image);

center_x = Window.GetX() + Window.GetWidth() / 2;
center_y = Window.GetY() + Window.GetHeight() / 2;

logo.SetX(center_x - logo_image.GetWidth() / 2);
logo.SetY(center_y - logo_image.GetHeight() / 2 - 14);

dot_y = center_y + 128;
dot1.SetX(center_x - 34);
dot2.SetX(center_x - 8);
dot3.SetX(center_x + 18);
dot1.SetY(dot_y);
dot2.SetY(dot_y);
dot3.SetY(dot_y);

phase = 0;
pulse = 0.0;
direction = 1;

fun refresh_callback()
{
  pulse = pulse + (0.015 * direction);
  if (pulse > 0.14)
  {
    pulse = 0.14;
    direction = -1;
  }
  if (pulse < 0.0)
  {
    pulse = 0.0;
    direction = 1;
  }

  logo.SetOpacity(0.82 + pulse);

  phase = phase + 1;
  if (phase > 2)
  {
    phase = 0;
  }

  dot1.SetOpacity(0.32);
  dot2.SetOpacity(0.32);
  dot3.SetOpacity(0.32);

  if (phase == 0)
  {
    dot1.SetOpacity(1.0);
  }
  if (phase == 1)
  {
    dot2.SetOpacity(1.0);
  }
  if (phase == 2)
  {
    dot3.SetOpacity(1.0);
  }
}

Plymouth.SetRefreshFunction(refresh_callback);
EOF
  '';
in
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 10;
    extraEntries = ''
      menuentry "Windows 10" {
        insmod part_gpt
        insmod fat
        insmod chain
        search --no-floppy --fs-uuid --set=root 2B7B-F2F7
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages;

  boot.kernelParams = [
    "threadirqs"
    "ipv6.disable=1"
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  boot.plymouth = {
    enable = true;
    theme = "tokyo-night";
    themePackages = [ plymouthTokyoNightTheme ];
  };

  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "fs.inotify.max_user_watches" = 8388608;
    "fs.inotify.max_user_instances" = 32768;
    "fs.inotify.max_queued_events" = 1048576;
  };
}
