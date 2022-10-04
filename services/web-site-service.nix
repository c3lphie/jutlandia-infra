{ config, pkgs, ... }:
let
  website = pkgs.callPackage ./Website {};
in
{

  systemd.services.website = {
    description = "Jutlandia Website service";
    after = [
      "network.target"
      "website_secrets.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = "/run/keys/website_secrets";
      PermissionsStartOnly = true;
      LimitNPROC = 512;
      LimitNOFILE = 1048576;
      NoNewPrivileges = true;
      DynamicUser = true;
      ExecStart = ''${website}/bin/jutlandia'';
      Restart = "on-failure";
    };
  };
}
  
