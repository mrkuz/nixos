{ ... }:

let
  flake = import /etc/nixos/current;
in
flake.nixosConfigurations.${builtins.getEnv "CONFIG_NAME"}
