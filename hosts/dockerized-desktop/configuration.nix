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

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;
    desktopManager.xfce.enable = true;
  };

  # port: 3389
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
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

  home-manager.users.user = ../../users/user/home.nix;
}
