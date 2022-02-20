{ config, pkgs, ... }:
let
  limgrisen = pkgs.callPackage ./package {
    nodejs = pkgs.nodejs-16_x;
  };
in
  {
    systemd.services.limgrisen = {
      description = "Limgrisen CTF bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        NoNewPrivileges = true;
        DynamicUser = true;
        ExecStart = "${pkgs.nodejs-16_x}/bin/node ${limgrisen.package}/lib/node_modules/Limgrisen/src/index.js /home/limgrisen/limgrisen/config.json";
        Restart = "on-failure";
      };
    };
  }
