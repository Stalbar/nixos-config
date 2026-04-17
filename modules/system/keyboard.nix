{ pkgs, ... }:

{
  hardware.keyboard.qmk.enable = true;

  # Install the Vial hidraw access rule with the filename/order recommended by
  # the upstream Linux manual so the rule is applied before later hidraw rules.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "vial-udev-rules";
      destination = "/lib/udev/rules.d/59-vial.rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    })
  ];
}
