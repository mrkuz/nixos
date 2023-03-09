{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/hosts/docker.nix
  ];

  networking = {
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };
}
