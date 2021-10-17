{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8"
 ];
    defaultGateway = "165.232.64.1";
    defaultGateway6 = "";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="165.232.68.190"; prefixLength=20; }
{ address="10.19.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::101f:2fff:fe99:b985"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "165.232.64.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="12:1f:2f:99:b9:85", NAME="eth0"
    ATTR{address}=="2a:03:f8:db:38:ca", NAME="eth1"
  '';
}
