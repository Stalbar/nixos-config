{ ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.wifi.powersave = false;

  # Keep the Intel 9462 radio in active mode. Do not force-disable 802.11n:
  # that caps the current 2.4 GHz link at legacy 54 Mbit/s rates.
  boot.extraModprobeConfig = ''
    options iwlmvm power_scheme=1
  '';

  services.resolved.enable = true;

  networking.wg-quick.interfaces.wg0 = {
    configFile = "/etc/wireguard/wg0.conf";
    autostart = true;
  };

  networking.firewall.checkReversePath = "loose";

  networking.enableIPv6 = false;

  boot.kernel.sysctl = {
    "net.ipv4.ip_default_ttl" = 65;
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
  };

  networking.extraHosts = ''
    172.19.255.200 bff.helpdesk.local
    172.19.255.200 auth.helpdesk.local
    172.19.255.200 app.helpdesk.local
    127.0.0.1 zitadel.zitadel.svc.cluster.local
  '';
}
