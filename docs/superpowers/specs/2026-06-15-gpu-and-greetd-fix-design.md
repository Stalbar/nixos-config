# Design Spec: GPU and Greetd Boot Loop Fix

## Context & Problem Statement
The system is currently failing to reach the login manager and going into an infinite loop when booting the latest NixOS generations. In addition, there are issues connecting an external monitor to the laptop.

### Root Causes
1. **Greetd/ReGreet Crash Loop**:
   - The greeter uses `cage` (a Wayland compositor) with `programs.regreet.cageArgs = [ "-s" "-m" "extend" ]`.
   - On a hybrid GPU laptop (Intel iGPU + NVIDIA dGPU), trying to run `cage` in `extend` mode across multiple GPUs/displays without explicit setup crashes the compositor or fails to initialize.
   - The default `regreet` command lacks environment variables (`GTK_USE_PORTAL=0`, `GDK_DEBUG=no-portals`) to bypass desktop portal initialization, which crashes under the minimalist `cage` compositor.

2. **External Monitor Connection**:
   - The HDMI port is wired directly to the NVIDIA dGPU.
   - Because the system uses NVIDIA PRIME Offload, the dGPU is kept asleep, and the user session (Hyprland / Niri) does not automatically recognize the external monitor ports.
   - The compositor needs explicit GPU ordering (`AQ_DRM_DEVICES` for Hyprland 0.55+, `WLR_DRM_DEVICES` for Niri/wlroots) to use the Intel iGPU for rendering and the NVIDIA dGPU for outputs (Reverse PRIME).

---

## Proposed Solution

### 1. Fix Greetd/ReGreet Session (`modules/desktop/login.nix`)
- Configure `programs.regreet.cageArgs` to use `-m last` to only render the login screen on the active monitor.
- Override `services.greetd.settings.default_session.command` to define the startup command explicitly with portal overrides and the primary/secondary GPU paths.

### 2. Configure Reverse PRIME for User Session (`modules/desktop/nvidia.nix`)
- Expose `AQ_DRM_DEVICES` and `WLR_DRM_DEVICES` system-wide using `environment.sessionVariables`.
- Map the Intel iGPU (`/dev/dri/by-path/pci-0000:00:02.0-card`) as the primary device and NVIDIA dGPU (`/dev/dri/by-path/pci-0000:01:00.0-card`) as the secondary device.

---

## Detailed Changes

### Changes to [modules/desktop/login.nix](file:///home/stalbar/nixos-config/modules/desktop/login.nix)
- Set `programs.regreet.cageArgs = [ "-s" "-m" "last" ]`
- Explicitly define `services.greetd.settings.default_session`:
  ```nix
  services.greetd = {
    enable = true;
    greeterManagesPlymouth = false;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.dbus}/bin/dbus-run-session env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals WLR_DRM_DEVICES=/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card AQ_DRM_DEVICES=/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card ${pkgs.cage}/bin/cage -s -m last -- ${pkgs.regreet}/bin/regreet";
      };
    };
  };
  ```

### Changes to [modules/desktop/nvidia.nix](file:///home/stalbar/nixos-config/modules/desktop/nvidia.nix)
- Add the `environment.sessionVariables` block:
  ```nix
  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
    WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
  };
  ```

---

## Verification Plan
1. Rebuild the system configuration using `sudo nixos-rebuild switch --flake .#laptop`.
2. Confirm the rebuild completes successfully.
3. Reboot the machine and verify:
   - The boot process lands successfully on the ReGreet login screen (no infinite loop).
   - Plugging in an external monitor displays the login screen (or user session) correctly.
