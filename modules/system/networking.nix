{ ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

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
}
