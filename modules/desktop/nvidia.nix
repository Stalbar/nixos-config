{ ... }:

{
  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:00:02.0", SYMLINK+="dri/by-name/igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", SYMLINK+="dri/by-name/dgpu"
  '';

  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/by-name/dgpu:/dev/dri/by-name/igpu";
    WLR_DRM_DEVICES = "/dev/dri/by-name/dgpu:/dev/dri/by-name/igpu";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    gsp.enable = false;
    nvidiaSettings = true;

    # Keep the dGPU on the conservative path; the experimental suspend/runtime
    # PM path has already caused instability on this laptop.
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    prime = {
      offload = {
        enable = true;
	enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
