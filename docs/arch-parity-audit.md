# Arch Parity Audit

Reference baseline: `/home/stalbar/Arch/.config`  
Audit date: 2026-02-28

## Ported (or intentionally replaced with Nix-native equivalent)

- Hyprland core session and keybindings:
  - `home/stalbar/programs/hyprland.nix`
  - Includes workspace/navigation/app binds and XF86 media/brightness binds.
- Waybar:
  - `home/stalbar/programs/waybar.nix`
  - Ported to minimal right-side Nordic layout.
- Notifications:
  - `home/stalbar/programs/notifications.nix`
  - `dunst` configured + `volume`/`brightness` scripts integrated.
- Theme stack:
  - `home/stalbar/programs/theme.nix`
  - Nordic GTK theme, Papirus-Dark icons, Bibata cursor, JetBrainsMono Nerd Font Mono.
- Terminal + shell UX:
  - `home/stalbar/programs/kitty.nix`
  - `home/stalbar/programs/zsh.nix` (includes Starship config; not Arch-identical, but intentionally Nord-focused).
- Wallpaper workflow:
  - `home/stalbar/programs/wallpaper.nix`
  - `swww` + `change-wallpaper` command.
- Core desktop packages:
  - `home/stalbar/profiles/base.nix`
  - Includes core apps/tooling (Thunar, Telegram, Obsidian, Okular, etc.).

## Missing / partial parity that still matters

### High impact

- Lockscreen + idle policy are not Nix-managed yet:
  - Arch had `hyprlock` config (`/home/stalbar/Arch/.config/hypr/hyprlock.conf`).
  - Current Nix config still uses external lock script path (`$HOME/code/bash/lock.sh`) in Hyprland bind.
  - No `hypridle` policy currently declared for lock/suspend timing.

### Medium impact

- App launcher parity:
  - Arch has `rofi` config (`/home/stalbar/Arch/.config/rofi/*`).
  - Current Nix config has no `rofi` package/config and no launcher keybind equivalent.
- Power menu parity:
  - Arch has `wlogout` config (`/home/stalbar/Arch/.config/wlogout/*`).
  - Current Nix config has no `wlogout` package/config or bind.

### Low impact / optional polish

- `fastfetch` custom config from Arch is not ported (package exists).
- `btop` custom config from Arch is not ported (package exists).
- App-specific configs not ported (only if you care): `mpv`, `qBittorrent`, `neovide`, `nvim` user config.
- `qt5ct`/`qt6ct`/`xsettingsd` Arch-style tweaks are not ported (mostly superseded by current GTK/Qt theme setup).

## Intentionally not ported

- Hyprland plugins (`hyprpm` ecosystem) and Quickshell IPC bindings:
  - intentionally excluded per current design goals.

## Recommended next parity order

1. Port `hyprlock` + add `hypridle` (Nix-managed lock/idle flow).
2. Port `rofi` (minimal Nordic style) and add launcher bind.
3. Port `wlogout` (minimal Nordic power menu) and add power-menu bind.
4. Port `fastfetch` + `btop` config polish.
