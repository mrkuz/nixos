{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/hosts/docker.nix
  ];

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

  environment.noXlibs = false;

  users = {
    groups.user.gid = 1000;
    users = {
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
