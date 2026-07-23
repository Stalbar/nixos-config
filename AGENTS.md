# NixOS + Hyprland Architecture Blueprint

This document outlines the architectural, visual, typography, and system infrastructure foundation for a modern, modular NixOS system managed via Flakes and Home Manager, utilizing Hyprland as the Wayland compositor.

## 1. Design Philosophy: Flat + Glassmorphism Hybrid
The visual language optimizes for a software engineering workflow by balancing extreme readability with spatial awareness.

*   **The "Work" (Flat / Minimalist):** Applications requiring high focus (terminal, code editor) utilize strict flat designs, high contrast, and zero visual distractions.
*   **The "Environment" (Glassmorphism):** System-level UI components (launchers, notification centers, floating widgets) use background blur and translucency to maintain visual hierarchy and context without cluttering the screen.

## 2. Core Application Stack & Window Management

*   **Compositor / Window Manager:** `Hyprland`
    *   *Layout Paradigm:* Dynamic "dwindle" (Fibonacci split) layout.
    *   *Rationale:* Superior hardware-accelerated blur/glassmorphism engine, flexible window rules, and robust IPC (`hyprctl`) for QML integration.
*   **Terminal Emulator:** `foot`
    *   *Rationale:* Insanely fast, lightweight, native Wayland rendering.
*   **Shell Environment:** `fish`
    *   *Rationale:* Excellent out-of-the-box syntax highlighting, autosuggestions, and scripting ease.
    *   *Integrations:* Paired with `direnv` (for automatic Nix shell loading per project directory), `starship` (for a fast, context-aware prompt), and `zoxide` (for smart directory navigation).
*   **Code Editor Frontend:** `neovide` (Neovim)
    *   *Configuration Note:* Must be launched with `--no-fork`.
*   **Browsers:**
    *   *Daily Driver:* Zen Browser.
    *   *Automation/Development:* Chromium (forced to Wayland via `--enable-features=UseOzonePlatform --ozone-platform=wayland`).

## 3. Typography & Font Stack

*   **Monospace (Code & Terminal):** `JetBrains Mono Nerd Font` (`pkgs.nerd-fonts.jetbrains-mono`)
*   **Proportional / Sans-Serif (QML & UI):** `Geist` (or `Inter`) (`pkgs.geist`)
*   **Symbol & Emoji Fallbacks:** `Noto Color Emoji`, `Symbola`

## 4. The Custom UI Layer (QML)

*   **Compositor Bridge:** `quickshell` (exposes Wayland `layer-shell` protocols to QML).
*   **Component Library:** `kirigami` (KDE's QML framework).

## 5. QML Widget Architecture

*   **The Main Status Bar:** Flat, opaque, pinned.
*   **The Omnibox Launcher:** Glassmorphism, floating center. Parses `.desktop` files and executes quick shell commands.
*   **Unified Action & Notification Center:** Glassmorphism, slide-out side panel for toggles, media (`mpris`), and notifications.
*   **Agent & Debugging Hub (SWE Special):** Glassmorphic container with flat text blocks. Surfacing logs from CLI agents and automated workflows.
*   **Volatile OSDs:** Minimal floating overlays for volume and brightness.

## 6. The "Invisible" Infrastructure (System Management)

A robust NixOS workstation requires more than just a window manager. The following subsystems ensure security, stability, and proper state management:

*   **Secret Management (`sops-nix`):** Encrypts sensitive data (passwords, API keys) inside the Nix store using your machine's SSH keys, ensuring configuration files remain safely declarable in public Git repositories.
*   **Declarative Disk Partitioning (`disko`):** Automates drive formatting and partitioning directly from your Flake, eliminating manual installation steps.
*   **Ephemeral State ("Impermanence"):** Setting the root (`/`) file system as a `tmpfs` (RAM disk) so it wipes completely on every reboot [cite: 1.1.1]. Only explicitly declared directories in `/persist` (via the Impermanence module) are kept [cite: 1.1.2], enforcing absolute declarative purity [cite: 1.1.3].
*   **Audio & Media (`pipewire`):** Modern low-latency audio routing via `pipewire` and `wireplumber`, replacing PulseAudio and enabling Wayland screen sharing.
*   **Login & Display Manager (`greetd`):** A lightweight daemon using `tuigreet` for a terminal-based login prompt before launching Hyprland.
*   **System Maintenance:** Automated garbage collection (`nix.gc`) and `nh` (Nix Helper) for cleaner, faster system rebuilds.

## 7. Color Scheme: Tokyo Night Neon

*   **Background (Base):** `#1a1b26`
*   **Foreground (Text):** `#c0caf5`
*   **Neon Cyan (Accent 1):** `#7dcfff`
*   **Neon Magenta (Accent 2):** `#bb9af7`
*   **Neon Green (Success):** `#9ece6a`
*   **Neon Red (Error):** `#f7768e`

*   **Theming Strategy:** Hex codes defined in `colors.nix` and injected into `foot.ini`, Hyprland (`col.active_border`), and Quickshell widgets via Home Manager.
