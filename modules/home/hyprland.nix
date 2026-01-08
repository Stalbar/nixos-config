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

      exec-once = [
      	"launch-waybar"
      ];

      input = {
	kb_layout = "us, ru";
	kb_options = "grp:win_space_toggle";
	follow_mouse = 1;
	sensitivity = 0;
	touchpad = {
	  natural_scroll = true;
	  middle_button_emulation = true;
	};
      };

      device = [
	{
	  name = "epic-mouse-v1"; sensitivity = -0.5; 
	}
	{
	  name = "elan1200:00-04f3:30ba-touchpad"; enabled = false; 
	}
      ];

      general = {
	gaps_in = 5;
	gaps_out = 10;
	border_size = 2;
	"col.active_border" = "rgb(f6c177) rgb(31748f) 45deg";
	"col.inactive_border" = "rgb(1f1d2e)";
	resize_on_border = true;
	layout = "dwindle";
      };

      decoration = {
	rounding = 10;
	active_opacity = 1.0;
	inactive_opacity = 0.9;
	blur = {
	  enabled = true;
	  size = 5;
	  passes = 2;
	  new_optimizations = true;
	};
	shadow = {
	  enabled = true;
	  range = 12;
	  render_power = 5;
	  color = "rgba(1a1a1aee)";
	};
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "easeOutCirc, 0.0, 0.0, 0.5, 1.0"
          "rofi_curve, 0.34, -0.09, 0, 0.96"
        ];
        animation = [
          "windows, 1, 7, myBezier, popin 80%"
          "windowsIn, 1, 7, myBezier, popin 80%"
          "windowsOut, 1, 7, myBezier, popin 80%"
          "workspaces, 1, 2, easeOutCirc, slidefade 20%"
          "fade, 1, 7, default"
        ];
      };

      bind = [
	
	"SUPER, V, togglefloating"
	"SUPER, F4, killactive"
	"SUPER, T, togglesplit"
	"SUPER, F, fullscreen"

	"ALT, SPACE, exec, rofi -show drun"
	"SUPER, S, exec, grimblast --freeze save area - | swappy -f -"
	
	"SUPER, 1, workspace, 1"
	"SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

	"SUPER SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER SHIFT, 8, movetoworkspacesilent, 8"
        "SUPER SHIFT, 9, movetoworkspacesilent, 9"
        "SUPER SHIFT, 0, movetoworkspacesilent, 10"

	"SUPER, Q, exec, kitty"
	"ALT, F, exec, firefox"

      ];
    };
  };
}
