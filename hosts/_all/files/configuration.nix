{ config, pkgs, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=/nix/channels/nixos" ];
  };

  system.stateVersion = "22.05";
}
