# Arch Parity Audit

Reference baseline: `/home/stalbar/Arch/.config`  
Audit date: 2026-03-02

## Ported

- Hyprland session, keybinds, and XF86 controls:
  - `home/stalbar/programs/hyprland.nix`
- Waybar right-side Nordic layout:
  - `home/stalbar/programs/waybar.nix`
- Notifications + volume/brightness scripts:
  - `home/stalbar/programs/notifications.nix`
- Lockscreen + idle flow:
  - `home/stalbar/programs/lock.nix`
- GTK/Qt/icon/cursor/font theming:
  - `home/stalbar/programs/theme.nix`
- Launcher + power menu:
  - `home/stalbar/programs/rofi.nix`
  - `home/stalbar/programs/wlogout.nix`
- Wallpaper workflow:
  - `home/stalbar/programs/wallpaper.nix`
- Fastfetch + btop theming:
  - `home/stalbar/programs/fastfetch.nix`
  - `home/stalbar/programs/btop.nix`
- Firefox + extensions + profile defaults:
  - `home/stalbar/programs/firefox.nix`
  - `home/stalbar/programs/firefox/profile.nix`
  - `home/stalbar/programs/firefox/extensions.nix`
- Boot/login visual stack:
  - `modules/system/boot.nix` (Plymouth)
  - `modules/system/grub-theme.nix`
  - `modules/desktop/login.nix` (greetd/tuigreet)

## Newly Staged For Quickshell Migration

- Quickshell runtime and helper launchers are prepared:
  - `home/stalbar/programs/quickshell.nix`
- Current behavior remains unchanged (`rofi` + `wlogout` still active).
- Hyprland commands are now variable-based for easier backend swap:
  - `home/stalbar/programs/hyprland.nix`

## Gaps Still Not Covered

### High impact

- Quickshell widgets are not yet in-repo:
  - No declarative `~/.config/quickshell/*` widget source managed by Home Manager yet.
- Greetd is still `tuigreet`-based:
  - No custom Quickshell greeter (`dms-greeter`) wired yet.

### Medium impact

- No secrets management framework yet:
  - WireGuard relies on `/etc/wireguard/wg0.conf`; no `sops-nix`/`agenix` integration.
- No automated Nix maintenance policy:
  - No scheduled GC/store optimization/update cadence module.

### Optional / quality

- No structured backup/restore policy beyond snapshots:
  - Snapper exists, but no off-device backup (restic/borg) module.
- No explicit desktop profile toggle set:
  - Current launcher/powermenu backends are editable in Hyprland vars, but not exposed as formal Home Manager options.

## Recommended Next Order

1. Vendor Quickshell widget source into this repo and manage it declaratively.
2. Add backend toggles (`rofi`/`wlogout` vs Quickshell) as formal options.
3. Switch launcher + power menu binds to Quickshell and remove legacy packages.
4. Move greetd from `tuigreet` to a themed Quickshell greeter.
5. Add secrets + backup policy modules (`sops-nix` + restic).
