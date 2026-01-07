{ config, pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    settings = {
      monitor = ",1920x1080@120,0x0,1";
      env = [
	"LIBVA_DRIVER_NAME,nvidia"
	"GBM_BACKEND,nvidia-drm"
	"__GLX_VENDOR_LIBRARY_NAME,nvidia"
	"NIXOS_OZONE_WL,1"
      ];
      
      bind = [
	"SUPER, F4, killactive"
	"SUPER, Q, exec, kitty"
	"ALT, F, exec, firefox"
      ];
    };
  };
}
