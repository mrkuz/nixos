{ config, pkgs, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=/nix/nixpkgs" ];
  };

  system.stateVersion = "20.09";
}

