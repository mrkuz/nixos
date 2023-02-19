{ ... }:

let
  flake = import /etc/nixos/current;
in
flake.legacyPackages.${builtins.currentSystem}
