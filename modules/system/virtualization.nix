{ ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    addNetworkInterface = false;
  };

  users.users.stalbar.extraGroups = [
    "vboxusers"
  ];
}
