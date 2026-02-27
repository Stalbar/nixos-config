{ ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  services.fstrim.enable = true;
}
