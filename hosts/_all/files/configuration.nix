{ config, pkgs, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=/nix/channels/nixos" ];
  };

  system.stateVersion = "20.09";
}

