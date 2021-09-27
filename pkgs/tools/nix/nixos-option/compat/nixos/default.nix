{ ... }:

let
  flake = import /nix/current;
in
flake.nixosConfigurations.${builtins.getEnv "CONFIG_NAME"}
