# Implementation Plan: GPU and Greetd Boot Loop Fix

This plan outlines the steps to resolve the boot loop and multi-GPU issues by applying the approved design.

## Proposed Steps

### Step 1: Modify `modules/desktop/login.nix`
- Replace `programs.regreet.cageArgs` to use `"-m last"`.
- Set `services.greetd.settings.default_session` explicitly to launch `cage` with `"-m last"` and the required environment variables (`GTK_USE_PORTAL=0`, `GDK_DEBUG=no-portals`, `WLR_DRM_DEVICES`, `AQ_DRM_DEVICES`).

### Step 2: Modify `modules/desktop/nvidia.nix`
- Add system-wide `environment.sessionVariables` containing `AQ_DRM_DEVICES` and `WLR_DRM_DEVICES` mapped to the Intel iGPU and NVIDIA dGPU.

### Step 3: Verify and Rebuild NixOS Configuration
- Run `nix flake check` or `nixos-rebuild dry-activate` to ensure no syntax errors.
- Run `sudo nixos-rebuild switch --flake .#laptop` (to be run by the user or using the command execution tool).
