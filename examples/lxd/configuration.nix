{ config, lib, pkgs, sources, profilesPath, ... }:

{
  imports = [
    "${profilesPath}/hosts/minimal.nix"
  ];

  modules = {
    lxdContainer.enable = true;
    nix.enable = true;
  };

  users = {
    groups.user.gid = 1000;
    mutableUsers = false;
    users = {
      root = {
        password = "root";
      };
    };
  };
}
