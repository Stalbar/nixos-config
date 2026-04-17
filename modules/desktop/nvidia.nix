{ ... }:

{
  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

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
