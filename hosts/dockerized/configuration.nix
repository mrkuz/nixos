{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/hosts/docker.nix
  ];

  networking = {
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };
}
