{ config, pkgs, ... }:
let
  website = pkgs.callPackage ../../services/Website {};
in
{
  imports = [
    ./hardware-configuration.nix
    ../../services/Limgrisen
    ./networking.nix # generated at runtime by nixos-infect
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/5675b122a947b40e551438df6a623efad19fd2e7/nixos-mailserver-5675b122a947b40e551438df6a623efad19fd2e7.tar.gz";
      sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
    })
  ];

  swapDevices = [ { size = 1024; device = "/swapfile"; } ];

  boot.cleanTmpDir = true;
  networking.hostName = "Cimbrer";
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 80 443 465 993 143 25 ];
  networking.enableIPv6 = false;

  networking.nameservers = [ "91.239.100.100" "89.233.43.71" ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBSFM5naI64D1qR2Awu8V3LBl8FZ5vbKox1jKI7IF6V rendal@popper" ];

  users.users.limgrisen = {
    isNormalUser = true;
  };

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

  mailserver = {
    enable = true;
    fqdn = "mail.jutlandia.club";
    domains = [ "jutlandia.club" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "contact@jutlandia.club" = {
        # TODO: Manage this using nixops
        # Or why bother?
        hashedPasswordFile = "/var/secrets/mail_password.txt";
        aliases = ["postmaster@example.com"];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;
  };

  virtualisation.docker.enable = true;

  security.acme.acceptTerms = true;
  security.acme.email = "rasmus@rend.al";

  environment.systemPackages = with pkgs; [ neovim htop git tmux docker-compose ];

}
