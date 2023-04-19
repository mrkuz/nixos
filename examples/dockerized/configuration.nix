{ config, lib, pkgs, sources, profilesPath, ... }:

{
  imports = [
    "${profilesPath}/hosts/minimal.nix"
  ];

  modules = {
    dockerContainer.enable = true;
  };

  networking = {
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };

  system.disableInstallerTools = true;
  environment.noXlibs = true;

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };
}
