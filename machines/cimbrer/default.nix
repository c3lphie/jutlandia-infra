{ config, pkgs, ... }:
let
  website = pkgs.callPackage ../../services/Website {};
in
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  swapDevices = [ {
    size = 1024;
    device = "/swapfile";
  } ];

  boot.cleanTmpDir = true;
  networking.hostName = "Cimbrer";
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBSFM5naI64D1qR2Awu8V3LBl8FZ5vbKox1jKI7IF6V rendal@popper" ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "jutlandia.club" = {
        forceSSL = true;
        enableACME = true;
        locations."/".root = "${website}";
        serverAliases = [ "www.jutlandia.club" ];
      };
      "pad.jutlandia.club" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8080";
      };
    };
  };

  virtualisation.docker.enable = true;

  security.acme.acceptTerms = true;
  security.acme.email = "rasmus@rend.al";

  environment.systemPackages = with pkgs; [ neovim htop git tmux docker-compose ];
}

