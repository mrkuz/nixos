{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/hosts/minimal.nix
  ];

  modules = {
    dockerContainer.enable = true;
  };

  networking = {
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };

  system.disableInstallerTools = true;
  environment.noXlibs = lib.mkDefault true;

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };
}
