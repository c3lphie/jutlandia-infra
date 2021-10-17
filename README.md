# Jutlandia Infra
The infra of Jutlandia is run using [nixops](https://github.com/NixOS/nixops).
I do not guarantee that I know how to use nixops.
## Deployment
To deploy the infra, run the following two commands
```
nixops create deployment.nix -d jutlandia
nixops deploy -d jutlandia
```
