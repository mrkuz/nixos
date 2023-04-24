{ config, lib, pkgs, sources, profilesPath, ... }:

{
  imports = [
    "${profilesPath}/hosts/minimal.nix"
  ];

  modules = {
    lxdVm.enable = true;
    nix = {
      enable = true;
      minimal = true;
    };
  };

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.defaultSession = "xfce";
  };

  users = {
    groups.user.gid = 1000;
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
      user = {
        uid = 1000;
        description = "User";
        isNormalUser = true;
        group = "user";
        extraGroups = [ "wheel" ];
        password = "user";
      };
    };
  };
}
