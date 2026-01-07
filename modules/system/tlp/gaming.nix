{ lib, ... }: {
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = lib.mkForce "powersave";
    
    CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT= lib.mkForce "power";

    CPU_BOOST_ON_AC = lib.mkForce 0;
    CPU_BOOST_ON_BAT = lib.mkForce 0;

    CPU_HWP_DYN_BOOST_ON_AC = lib.mkForce 0;
    CPU_HWP_DYN_BOOST_ON_BAT = lib.mkForce 0;

    PLATFORM_PROFILE_ON_AC = lib.mkForce "performance";
    PLATFORM_PROFILE_ON_BAT = lib.mkForce "low-power";

    AHCI_RUNTIME_PM_ON_AC = lib.mkForce "auto";
    AHCI_RUNTIME_PM_ON_BAT = lib.mkForce "auto";

    RUNTIME_PM_ON_AC = lib.mkForce "on";
    RUNTIME_PM_ON_BAT = lib.mkForce "auto";
  };
}
