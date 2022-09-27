{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "138.68.96.1";
    # defaultGateway6 = {
    #   address = "2a03:b0c0:3:d0::1";
    #   interface = "eth0";
    # };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    enableIPv6 = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="138.68.106.52"; prefixLength=20; }
          { address="10.19.0.5"; prefixLength=16; }
        ];
        ipv4.routes = [ { address = "138.68.96.1"; prefixLength = 32; } ];

        # ipv6.addresses = [
        #   { address="2a03:b0c0:3:d0::12b1:5001"; prefixLength=64; }
        #   { address="fe80::cce8:9bff:fea5:32e4"; prefixLength=64; }
        # ];
        # ipv6.routes = [ { address = "2a03:b0c0:3:d0::1"; prefixLength = 128; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="ce:e8:9b:a5:32:e4", NAME="eth0"
    # ATTR{address}=="6a:e7:76:cb:11:c4", NAME="eth1"
  '';
}
