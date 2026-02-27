{ ... }:

{
  services.irqbalance.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 15;
        CPU_MAX_PERF_ON_AC = 90;

        CPU_MIN_PERF_ON_BAT = 5;
        CPU_MAX_PERF_ON_BAT = 60;

        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;

        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        USB_AUTOSUSPEND = 1;
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";
      };
  };
}
