{ ... }: {
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
    CPU_ENERGY_PERF_POLICY_ON_BAT= "power";

    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;

    CPU_HWP_DYN_BOOST_ON_AC = 0;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;

    PLATFORM_PROFILE_ON_AC = "balanced";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    AHCI_RUNTIME_PM_ON_AC = "auto";
    AHCI_RUNTIME_PM_ON_BAT = "auto";

    RUNTIME_PM_ON_AC = "on";
    RUNTIME_PM_ON_BAT = "auto";
  };
}
