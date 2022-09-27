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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5xpdDoVaGyVOxYVUxz+w1J++LuBKirm/NndcsvTffYuKh/yCBC0eZXvGZRcM55W1Tc5T7XaOLMF53veqPVrg2jqB2fyiq8kT4TWBK7ati1/kYjFlGMrOmx1nUOCo7jJ0b7nqbZFxm3lPQAuuDJsfOYHBjKHivbqx/WO2AiwLLx8yDOCBSjdOXqGnP2YkeJa0JEF00IMrmyS03ZMVcQh5h097bFkxf8TsMsageAiHT+W3du8iPirY9DnkC+PM0P4b9DHOlTRRdVxgGSVWePPtXv08DvqKqNVf3VoTD+5eHD1QyIkR31/4WVSZ9Ce5O6RTFr6O1/IpsJjeSnDHPUPiq1XI2tbux044yCDmUquQJNCPQwBtbxRxMBgl0nLQfk5CQGEBe7sc08dB578+Q1OVcsh3hTjKj4tkhI1G4Mmknyh87QzXQrBrYdESnhuSLk/uy4OXU7zpCcG+5wINOBg3z3zGue1xdy3yQz07lnlcLfDRCcXPd+PqOvJYWToSEChOSse8MzfBPiqlS5Xn7TPasx9SpwaU8cmdXY6xvuWgM0dyFrn6C28iih3M1PXQ3eTMnQN9/rJJMmDF40Xs+HhWDhxlZiSR/GCPwXjy0zzS/Q8HwgVPFxhjoNw3a/uaN1eH5wTteJIp69ViH5QvDzWJwhCQYeY3QsNBKmgpco+20ow== cardno:15 489 316"
  ];

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
