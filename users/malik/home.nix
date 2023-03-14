{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/users/nixos.nix
  ];

  home.packages = with pkgs; [
    gcompris
  ];
}
