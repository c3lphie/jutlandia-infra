{
  network = {
    enableRollback = true;
    description = "Infra structure for Jutlandia CTF team";
  };
  cimbrer = {
    imports = [ ./machines/cimbrer ];
    deployment.targetHost = "jutlandia.club";
  };
}
