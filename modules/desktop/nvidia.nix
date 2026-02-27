{ ... }:

{
  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

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
