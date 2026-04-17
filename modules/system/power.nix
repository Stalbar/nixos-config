{ ... }:

{
  services.irqbalance.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # TLP 1.9 profiles are repurposed as named modes:
      # - balanced: quiet/default low-noise profile
      # - performance: opt-in gaming / burst profile
      # - power-saver: extra battery-saver override
      TLP_AUTO_SWITCH = 0;
      TLP_DEFAULT_MODE = "BAL";
      TLP_PERSISTENT_DEFAULT = 0;

      # performance profile -> manual high-power mode
      PLATFORM_PROFILE_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      AHCI_RUNTIME_PM_ON_AC = "on";
      WIFI_PWR_ON_AC = "off";
      PCIE_ASPM_ON_AC = "performance";
      RUNTIME_PM_ON_AC = "on";
      SOUND_POWER_SAVE_ON_AC = 0;

      # balanced profile -> quiet default with enough headroom for desktop/dev work
      PLATFORM_PROFILE_ON_BAT = "balanced";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 70;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_BAT = "off";
      PCIE_ASPM_ON_BAT = "powersave";
      RUNTIME_PM_ON_BAT = "auto";
      SOUND_POWER_SAVE_ON_BAT = 1;

      # power-saver profile -> stricter cap for battery/very quiet mode
      PLATFORM_PROFILE_ON_SAV = "low-power";
      CPU_SCALING_GOVERNOR_ON_SAV = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
      CPU_MIN_PERF_ON_SAV = 0;
      CPU_MAX_PERF_ON_SAV = 45;
      CPU_BOOST_ON_SAV = 0;
      CPU_HWP_DYN_BOOST_ON_SAV = 0;
      AHCI_RUNTIME_PM_ON_SAV = "auto";
      WIFI_PWR_ON_SAV = "on";
      PCIE_ASPM_ON_SAV = "powersupersave";
      RUNTIME_PM_ON_SAV = "auto";
      SOUND_POWER_SAVE_ON_SAV = 1;

      # Wireless HID receivers should stay awake; autosuspend can leave them
      # present electrically but missing from the input stack after resume.
      USB_AUTOSUSPEND = 0;
      SOUND_POWER_SAVE_CONTROLLER = "Y";
    };
  };
}
