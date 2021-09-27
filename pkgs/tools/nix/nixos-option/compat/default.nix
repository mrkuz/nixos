{ ... }:

let
  flake = import /nix/current;
in
flake.legacyPackages.${builtins.currentSystem}
